state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

// --- Startup: load helpers and settings ---
startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.Settings.CreateFromXml("Components/SilentHillf.Settings.xml");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
    vars.Uhara.EnableDebug();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");

    vars.CompletedSplits = new HashSet<string>();
    vars.FNameCache = new Dictionary<ulong, string>();

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
        throw new Exception("Required addresses not found.");

    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        int nameIdx = (int)((fName & 0x000000000000FFFF) >> 0x00);
        int chunkIdx = (int)((fName & 0x00000000FFFF0000) >> 0x10);
        long number = (long)((fName & 0xFFFFFFFF00000000) >> 0x20);

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + chunkIdx * 0x8);
        IntPtr entry = chunk + nameIdx * sizeof(short);
        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    // --- Cutscene watcher ---
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    var WBP_Cutscene_C = Events.InstancePtr("WBP_Cutscene_C", "");
    vars.Helper["CutsceneName"] = vars.Helper.Make<ulong>(WBP_Cutscene_C, 0x460);
    vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

    // --- bIsInEvent watcher ---
    vars.Helper["bIsInEvent"] = vars.Helper.Make<bool>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x298, 0x708);

    current.Cutscene = "";
    vars.cutsceneStarted = false;
    vars.cutsceneHold = false;
    vars.cutsceneActive = false;

    // --- Watched cutscenes ---
    vars.CutscenesToWatch = new HashSet<string>() 
    { 
        "LS_SC0106",
        "LS_SC0203", 
        "LS_SC0303", 
        "LS_SC0404", 
        "LS_SC0504" 
    };
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    // Read current cutscene
    ulong cutsceneNameFName = vars.Helper["CutsceneName"].Current;
    string cutscene = vars.FNameToString(cutsceneNameFName);
    string newCutscene = (!string.IsNullOrEmpty(cutscene) && cutscene != "None") ? cutscene : "";

    // Log only on change
    if (newCutscene != current.Cutscene)
    {
        if (!string.IsNullOrEmpty(newCutscene))
            vars.Log("Current Cutscene Started: " + newCutscene);
        else
            vars.Log("No Cutscene Active");

        current.Cutscene = newCutscene;
    }
}

isLoading
{
    bool hasCutscene = !string.IsNullOrEmpty(current.Cutscene);
    bool loading = false;
    bool loading2 = vars.cutsceneHold;

    if (hasCutscene || vars.cutsceneActive)
    {
        vars.cutsceneActive = true;
        loading = true;

        if (!hasCutscene && !current.bIsInEvent)
        {
            vars.cutsceneActive = false;
            vars.Log("Main Loading Sequence Ended");
        }
    }

    if (!vars.cutsceneHold && hasCutscene && vars.CutscenesToWatch.Contains(current.Cutscene.Substring(0, 9)))
    {
        vars.cutsceneHold = true;
        vars.Log("Watched Cutscene Started: " + current.Cutscene);
    }

    if (vars.cutsceneHold && hasCutscene && !vars.CutscenesToWatch.Contains(current.Cutscene.Substring(0, 9)))
    {
        vars.cutsceneHold = false;
        vars.Log("Watched Cutscene Ended");
    }

    return loading || loading2;
}
