state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
    vars.Uhara.EnableDebug();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");
    IntPtr gSyncLoad = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");

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

    vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});

    // uhara9
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr WBP_Cutscene_C = Events.InstancePtr("WBP_Cutscene_C", "");
    vars.Helper["CutsceneName"] = vars.Helper.Make<uint>(WBP_Cutscene_C, 0x460);
    vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
        
    // asl-help
    vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x18);
    vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
    vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x18);
	vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
    vars.Helper["isLoading"] = vars.Helper.Make<bool>(gSyncLoad);
    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    vars.Helper["IsGameInitialized"] = vars.Helper.Make<bool>(gWorld, 0x158, 0x37A);
    vars.Helper["bWaitForRevive"] = vars.Helper.Make<bool>(gWorld, 0x158, 0x3B1);

    current.World = "";
    current.Progress = "";
    current.Cutscene = "";
    current.CutsceneName = 0;
}

start
{
    return old.Cutscene == "LS_SC0101_L1_M" && current.Cutscene != "LS_SC0101_L1_M";
}

onStart
{
    timer.IsGameTimePaused = true;
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World) vars.Log("World: " + current.World);

    if (current.CutsceneName != old.CutsceneName)
    {
        if (current.CutsceneName != 0)
        {
            string cutscene = vars.FNameToString(current.CutsceneName);
            if (!string.IsNullOrEmpty(cutscene)) current.Cutscene = cutscene;
        }
        else current.Cutscene = "";
    }
}

isLoading
{
    return current.World == "NoceEntry" || current.bWaitForRevive || !current.IsGameInitialized || current.isLoading 
    || !string.IsNullOrEmpty(current.Cutscene) || vars.FNameToShortString2(current.LocalPlayer) != "BP_Pl_Hina_PlayerController_C_";
}