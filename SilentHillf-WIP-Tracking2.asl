state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
    vars.Uhara.EnableDebug();

    // Make the file on desktop
    var desktop = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
    var path = Path.Combine(desktop, "SilentHillf.txt");
    vars.Writer = new StreamWriter(path);

    // Wrap vars.Log so it also writes to file with timestamps (no $)
    var oldLog = vars.Log; // save original console logger
    vars.Log = (Action<string>)((msg) => {
        string stamped = "[" + 
                         DateTime.Now.Hour.ToString("D2") + ":" +
                         DateTime.Now.Minute.ToString("D2") + ":" +
                         DateTime.Now.Second.ToString("D2") + "] " + msg;
        oldLog(stamped);                 // console
        vars.Writer.WriteLine(stamped);  // file
        vars.Writer.Flush();
    });
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");

    vars.GEngine = gEngine;

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
        throw new Exception("Not all required addresses could be found by scanning.");

    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);
        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    // uhara9
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr WBP_Cutscene_C = Events.InstancePtr("WBP_Cutscene_C", "");
    vars.Helper["CutsceneName"] = vars.Helper.Make<uint>(WBP_Cutscene_C, 0x460);
    vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
        
    // asl-help
    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    // GWorld -> GameState -> GameProgress -> ExactProgressTag
    vars.Helper["ProgressTag"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x328, 0x250);

    current.World = "";
    current.Progress = "";
    current.Cutscene = "";
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName);
    if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World) 
        vars.Log("World: " + current.World);

    var progress = vars.FNameToString(current.ProgressTag);
    if (!string.IsNullOrEmpty(progress)) current.Progress = progress;
    // Only log progress if we're in NoceWorld
    if (old.Progress != current.Progress && current.World == "NoceWorld") 
        vars.Log("Progress: " + current.Progress);

    if (current.CutsceneName != old.CutsceneName)
    {
        if (current.CutsceneName != 0)
        {
            string cutscene = vars.FNameToString(current.CutsceneName);
            current.Cutscene = cutscene ?? ""; // assign even if null
        }
        else current.Cutscene = "";
    }

    if (old.Cutscene != current.Cutscene) 
        vars.Log("Cutscene: " + current.Cutscene);
}

shutdown
{
    if (vars.Writer != null)
        vars.Writer.Close();
}
