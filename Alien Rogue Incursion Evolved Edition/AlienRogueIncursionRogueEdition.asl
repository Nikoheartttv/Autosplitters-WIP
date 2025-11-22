state("Midnight-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
	vars.Helper.GameName = "Alien: Rogue Incursion Evolved Edition";
	vars.Helper.AlertLoadless();
	
    dynamic[,] _settings =
	{
		{ "MissionSplits", true, "Mission Splits", null },
			{ "M1.02 SurfaceBreak", true, "Exit the Ship and begin the search for Carver", "MissionSplits"},
            { "M1.03 FirstSaveBreak", true, "First Save Break", "MissionSplits"},
            { "M1.06 ControlRoomBreak", true, "Control Room Break", "MissionSplits"},
            // { "M1.09 AlarmCombat", true, "Alarm Combat", "MissionSplits"},
            // { "M1.10 SurfaceCombat", true, "Surface Combat", "MissionSplits"},
            { "M1.11 DavisAirlockBreak", true, "Davis Airlock Break", "MissionSplits"},
            { "M2.2 PostPlasmaTorchCombat", true, "Post Plasma Torch Combat", "MissionSplits"},
            { "M2.3 AdminCombat", true, "Admin Combat", "MissionSplits"},
            //




	};
	vars.Helper.Settings.Create(_settings);

	vars.CompletedSplits = new HashSet<string>();
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
	IntPtr fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");

	// current.GEngine = gEngine;

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
    {
        const string Msg = "Not all required addresses could be found by scanning.";
        throw new Exception(Msg);
    }

    if (gWorld != IntPtr.Zero) vars.Log("gWorld: " + gWorld.ToString("X"));
    if (gEngine != IntPtr.Zero) vars.Log("gEngine: " + gEngine.ToString("X"));
    if (fNames != IntPtr.Zero) vars.Log("fNames: " + fNames.ToString("X"));

	vars.Helper.Update();
	vars.Helper.MapPointers();

    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr Test = Events.InstancePtr("InputPlatformSettings", "InputPlatformSettings_Windows");

    // if (fNames == IntPtr.Zero)
    // {
    //     const string Msg = "Not all required addresses could be found by scanning.";
    //     throw new Exception(Msg);
    // }
    // vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

    vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

		// IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name + "_" + number;
	});

	vars.FindSubsystem = (Func<string, IntPtr>)(name =>
    {
		// GEngine.GameInstance.currentnumberofsubsystems
        var subsystems = vars.Helper.Read<int>(gEngine, 0x11F8, 0x110);
        for (int i = 0; i < subsystems; i++)
        {
			//GEngine.GameInstance.subsystem finds on every 0x18 plus 0x8
            var subsystem = vars.Helper.Deref(gEngine, 0x11F8, 0x108, 0x18 * i + 0x8);
            var sysName = vars.FNameToString(vars.Helper.Read<ulong>(subsystem, 0x18));

            if (sysName.StartsWith(name))
            {
                return subsystem;
            }
        }

        throw new InvalidOperationException("Subsystem not found: " + name);
    });
	vars.MNQuestObjectiveSubsystem = IntPtr.Zero;
    vars.MNCampaignAnalyticsGameInstanceSubsystem = IntPtr.Zero;

    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
	// vars.Helper["ObjectiveTask"] = vars.Helper.Make<int>(gEngine, 0x11F8, 0x108, 0x278, 0x68);
	vars.Helper["MNQuestObjectiveSubsystem"] = vars.Helper.Make<ulong>(gEngine, 0x11F8, 0x108, 0x278, 0x18);
    vars.Helper["bIsInCinematicMode"] = vars.Helper.Make<bool>(gEngine, 0x11F8, 0x38, 0x0, 0x30, 0x3A0, 0x639);
    // vars.Helper["GWorldName"] = vars.Helper.Make<uint>(gEngine, 0xBD0, 0x78, 0x18);
    // vars.Helper["IsGameInitialized"] = vars.Helper.Make<bool>(gWorld, 0x158, 0x37A);
    current.World = "";
	current.Test = "";
    current.TrackedObjectiveTaskHandle = 0;
    current.ActiveGameBeat = "";
    current.bIsInCinematicMode = false;
}

update
{
	IntPtr gm;
    if (!vars.Helper.TryRead<IntPtr>(out gm, vars.MNQuestObjectiveSubsystem))
    {
        vars.MNQuestObjectiveSubsystem = vars.FindSubsystem("MNQuestObjectiveSubsystem");
        // if (vars.ChaptersManager != IntPtr.Zero) vars.Log("MNQuestObjectiveSubsystem: " + vars.ChaptersManager.ToString("X"));
        vars.Helper["TrackedObjectiveTaskHandle"] = vars.Helper.Make<int>(vars.MNQuestObjectiveSubsystem, 0x68);
    }

    IntPtr gm2;
    if (!vars.Helper.TryRead<IntPtr>(out gm2, vars.MNCampaignAnalyticsGameInstanceSubsystem))
    {
        vars.MNCampaignAnalyticsGameInstanceSubsystem = vars.FindSubsystem("MNCampaignAnalyticsGameInstanceSubsystem");
        vars.Helper["ActiveGameBeat"] = vars.Helper.MakeString(vars.MNCampaignAnalyticsGameInstanceSubsystem, 0x1B0, 0x0);
    }

	vars.Helper.Update();
	vars.Helper.MapPointers();

    string world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World) vars.Log("World: " + current.World);

	string quest = vars.FNameToString(current.MNQuestObjectiveSubsystem);
	if (!string.IsNullOrEmpty(quest)) current.Test = quest;
    if (old.Test != current.Test) vars.Log("Test: " + current.Test);

	if (old.TrackedObjectiveTaskHandle != current.TrackedObjectiveTaskHandle) vars.Log("Objective Task: " + current.TrackedObjectiveTaskHandle);
    if (old.ActiveGameBeat != current.ActiveGameBeat) vars.Log("Active Game Beat: " + current.ActiveGameBeat);
    if (old.bIsInCinematicMode != current.bIsInCinematicMode) vars.Log("Cinematic Mode: " + current.bIsInCinematicMode);
}

// start
// {
//     return current.World == "L_Waking_Up_01" && current.bIsInCinematicMode == true;
// }

split
{
    if (old.ActiveGameBeat != current.ActiveGameBeat && !vars.CompletedSplits.Contains(current.ActiveGameBeat))
    {
        vars.CompletedSplits.Add(current.ActiveGameBeat);
        if (settings[current.ActiveGameBeat]) return true;
    }
}

// isLoading
// {
//     return current.bIsInCinematicMode;
// }