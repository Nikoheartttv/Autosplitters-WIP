state("GrandmaNo_UE5-Win64-Shipping") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.GameName = "Grandma, No! (SNF Demo)";
	vars.Helper.AlertLoadless();

	dynamic[,] _settings =
	{
		{ "Splits", true, "Splits", null },
			{ "3", true, "Act Two - Part One / Whirl Pool", "Splits" },
			{ "4", true, "Prologue - Calibration", "Splits"},
			{ "PrologueDone", true, "Prologue - Body Removal", "Splits"},
			{ "13", true, "Chapter 1 - Black Water", "Splits"},
			{ "ChaseAndEscape", true, "Chapter 1 - Chase & Escape", "Splits"},
			{ "15", true, "Chapter 1 - TV Tower", "Splits"},
			{ "16", true, "Chapter 1 - Stamping Letters", "Splits"},
			{ "12", true, "Chapter 1 - The Chase", "Splits"},
			{ "Ending", true, "Chapter 1 - Demo End", "Splits"},
	};

	vars.Helper.Settings.Create(_settings);
	vars.CompletedSplits = new HashSet<string>();
}

onStart
{
	vars.CompletedSplits.Clear();
	// This makes sure the timer always starts at 0.00
	timer.IsGameTimePaused = true;
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(10, "80 7C 24 ?? 00 ?? ?? 48 8B 3D ???????? 48");
	IntPtr fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ?? ?? ?? ?? EB");

	if (gWorld == IntPtr.Zero || fNames == IntPtr.Zero)
	{
		const string Msg = "Not all required addresses could be found by scanning.";
		throw new Exception(Msg);
	}
	// GWorld.FNameIndex
	vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.Character.PauseLocked
    vars.Helper["PauseLocked"] = vars.Helper.Make<bool>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x2E0, 0x856);
    vars.Helper["RagdollGroundedTimer"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x2E0, 0xB10);
    // // GWorld.AuthorityGameMode.CurrentChapter
    // vars.Helper["CurrentChapter"] = vars.Helper.Make<byte>(gWorld, 0x150, 0x349);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.FNameIndex
    // vars.Helper["CurrentPlayStartID"] = vars.Helper.Make<ulong>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0x9BC);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.LevelID
    // vars.Helper["LevelID"] = vars.Helper.Make<byte>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0xA00);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.WhereAmI?
    // vars.Helper["WhereAmI"] = vars.Helper.Make<byte>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0xBB9);
	// // GWorld.OwningGameInstance.stopParam
	// vars.Helper["stopParam"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x378);
	// // GWorld.OwningGameInstance.inMainMenu
	// vars.Helper["inMainMenu"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x37A);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.NoControl
    // vars.Helper["NoControl"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0x8B0);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.LockMovement
    // vars.Helper["LockMovement"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0x8B1);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.GamePause
    // vars.Helper["GamePause"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0x947);
    // // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.AcknwoledgedPawn.TimeStop
    // vars.Helper["TimeStop"] = vars.Helper.Make<bool>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0x9DA);
    // // GWorld.OwningGameInstance.GameMainUI.GM_Chapter.WhereAmI?
    // vars.Helper["WhereAmI"] = vars.Helper.Make<byte>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x338, 0xBB9);

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

	current.World = "";
	current.inMainMenu = false;
	current.stopParam = false;
    current.PlayStartID = "";

}

start
{
	// if (old.World == "Demo_TitleMap" && current.World == "Demo_FoyerScene")
    // {
    //     return old.RagdollGroundedTimer >= 0.1 && current.RagdollGroundedTimer == 0;
    // }
    return current.World == "Demo_FoyerScene" && old.RagdollGroundedTimer >= 0.1 && current.RagdollGroundedTimer == 0;
}

onStart
{
    timer.IsGameTimePaused = true;
	// vars.IntroNoControl = 0;
    vars.CompletedSplits.Clear();
}


update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();

	var world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;
		if (old.World != current.World) vars.Log("World: " + old.World + " -> " + current.World);
	if (old.PauseLocked != current.PauseLocked) vars.Log("PauseLocked:" + current.PauseLocked);
    if (old.RagdollGroundedTimer != current.RagdollGroundedTimer) vars.Log("RagdollGroundedTimer:" + current.RagdollGroundedTimer);

    // var playstartid = vars.FNameToString(current.CurrentPlayStartID);
	// if (!string.IsNullOrEmpty(playstartid) && playstartid != "None")
	// 	current.PlayStartID = playstartid;
	// 	if (old.PlayStartID != current.PlayStartID) vars.Log("PlayStartID: " + old.PlayStartID + " -> " + current.PlayStartID);

	// if (current.World == "ChapterOneRoot" && old.NoControl != current.NoControl) vars.IntroNoControl++;

	// if (old.GameProgress != current.GameProgress) vars.Log("GameProgress: " + old.GameProgress + " -> " + current.GameProgress);
	// if (old.GameProgress == 13 && current.GameProgress == 14) vars.GameProgress14++;
	// if (old.GameProgress == 16 && current.GameProgress == 12) vars.EndingPrep++;

    // if (old.LevelID != current.LevelID) vars.Log("LevelID: " + old.LevelID + " -> " + current.LevelID);
    // if (old.WhereAmI != current.WhereAmI) vars.Log("WhereAmI: " + old.WhereAmI + " -> " + current.WhereAmI);
    // if (old.CurrentChapter != current.CurrentChapter) vars.Log("CurrentChapter: " + old.CurrentChapter + " -> " + current.CurrentChapter);
    // if (old.NoControl != current.NoControl) vars.Log("NoControl: " + old.NoControl + " -> " + current.NoControl);
    // if (old.LockMovement != current.LockMovement) vars.Log("LockMovement: " + old.LockMovement + " -> " + current.LockMovement);
    // if (old.GamePause != current.GamePause) vars.Log("GamePause: " + old.GamePause + " -> " + current.GamePause);
    // if (old.TimeStop != current.TimeStop) vars.Log("TimeStop: " + old.TimeStop + " -> " + current.TimeStop);


}

split
{
}

isLoading
{
	return current.PauseLocked;
}