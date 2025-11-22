state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	// Assembly.Load(File.ReadAllBytes("Components/uhara8")).CreateInstance("Main");
	vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");
    IntPtr gSyncLoad = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
	{
		const string Msg = "Not all required addresses could be found by scanning.";
		throw new Exception(Msg);
	}

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

    vars.Helper["isLoading"] = vars.Helper.Make<bool>(gSyncLoad);
    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18); // GWorld.FName
    vars.Helper["Pause"] = vars.Helper.Make<bool>(gEngine, 0xBBB);
    // GEngine -> GameInstance -> LocalPlayers -> LocalPlayer -> PlayerController -> TimeManager
    // vars.Helper["TimeManager"] = vars.Helper.Make<IntPtr>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x990);
    vars.Helper["TimeManager"] = vars.Helper.Make<IntPtr>(gEngine, 0x10A8, 0x38, 0x0, 0x30);
    vars.Helper["IsGameInitialized"] = vars.Helper.Make<bool>(gWorld, 0x158, 0x37A);
    vars.Helper["bWaitForRevive"] = vars.Helper.Make<bool>(gWorld, 0x158, 0x3B1); // maybe?
    // vars.Helper["Transition"] = vars.Helper.MakeString(gEngine, 0xBC0, 0x0);
    vars.Helper["StreamingLevels"] = vars.Helper.Make<ulong>(gWorld, 0x88);

    // logging down what we see
    vars.Helper["OnDied"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x720);
    vars.Helper["BeginPlayGameTime"] = vars.Helper.Make<int>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x748);
    vars.Helper["TerritoryName"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x7A0);
    // CineActorComponent: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x7B8 (pointer)
    vars.Helper["CharacterName"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x7C0);
    vars.Helper["CharacterTagTagName"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x7C8);
    vars.Helper["CharacterLevel"] = vars.Helper.Make<float>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x7D0);
    // CharacterAbilities: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x9A0 (pointer)
    // Widgets: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x9E8 -> 0xB8 (pointer)
    vars.Helper["bSuicideDead"] = vars.Helper.Make<IntPtr>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9F2);
    vars.Helper["IsLoadingWidget"] = vars.Helper.Make<bool>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0x180);
    vars.Helper["CurrentSignificance"] = vars.Helper.Make<int>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0xA60);
    vars.Helper["MyPlayerType"] = vars.Helper.Make<int>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0xE08);
    // CurrentWeapon: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0xE10 (pointer)
    vars.Helper["EnemyInSightNumber"] = vars.Helper.Make<int>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0xF50);
    vars.Helper["DefaultEnemyInSightDistance"] = vars.Helper.Make<float>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0xF54);
    vars.Helper["CurrentEnemyInSightDistance"] = vars.Helper.Make<float>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0xF58);
    // GE_Battling: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x12D8 (pointer)
    // GE_InEvent: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x12E8 (pointer)
    // WBP_HUD: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x338 -> 0x1310 (pointer)
    // AbilitySystemComponent: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0x2E0 -> 0x990 (pointer)
    vars.Helper["VelocityX"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x320, 0xB8);
    vars.Helper["VelocityY"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x320, 0xC0);
    vars.Helper["VelocityZ"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x320, 0xC8);
    vars.Helper["ViewTargetPitch"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x348, 0x330);
    vars.Helper["ViewTargetYaw"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x348, 0x338);
    vars.Helper["ViewTargetRoll"] = vars.Helper.Make<double>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x348, 0x340);
    vars.Helper["IsReadyForInput"] = vars.Helper.Make<bool>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x988);

    vars.Helper["NewGame"] = vars.Helper.Make<int>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0xAA0, 0x728, 0x3B0);
    // MainMenuWidget: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0xAA0 (pointer)
    // NewGameWidget: gEngine -> 0x10A8 -> 0x38 -> 0x0 -> 0x30 -> 0xAA0 -> 0x728 (pointer)
    
    vars.Helper["StreamingLevels"] = vars.Helper.Make<ulong>(gWorld, 0x178, 0x8, 0x18);

    vars.Helper["StateName"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x2C8);

    vars.Helper["NewItemWidgetPath"] = vars.Helper.Make<bool>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x298, 0x6C8);
    vars.Helper["IsInEvent"] = vars.Helper.Make<bool>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x298, 0x708);

    vars.Helper["ProgressTagName"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x328, 0x224);
    vars.Helper["ExactProgressTagName"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x328, 0x250);
    vars.Helper["ExploreTagName"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x390);
    vars.Helper["MainStoryTagName"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x398);
    vars.Helper["StartNewGameTagName"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x3A0);

    vars.Helper["LoadedLevel"] = vars.Helper.Make<ulong>(gWorld, 0x88, 0xA0, 0x158, 0x18);

    vars.Helper["InteractTarget"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x278, 0x40, 0xA8);

    // vars.Helper["CutsceneName"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0xB0, 0x50, 0x460);
    // vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;


    // Widget at 0x50 for WBP_Cutscene.WBP_Cutscene_C may change, find way to solidly find it each iteration
    // CutsceneName: -> gEngine -> 0x10A8 -> 0x30 -> 0x0 -> 0x38 -> 0x338 -> 0x9E8 -> 0xB0 -> 0x50 -> 0x460 (pointer)

    vars.Helper.Update();
	vars.Helper.MapPointers();

    vars.Helper["GameEndingType"] = vars.Helper.Make<int>(gWorld, 0x158, 0x360); // Enum: TypeA_Massacre = 0, TypeB_Marriage = 1, TypeC_Escape = 2, TypeD_TroubledYouth = 3, TypeE_UFO = 4

    current.World = "";
    current.Level = "";
    current.Pause = false;
    current.Transition = "";
    current.Cutscene = "";
    current.CutsceneFname = "";
    current.TimeManager = IntPtr.Zero;
}

update
{
    vars.Helper.Update();
	vars.Helper.MapPointers();

    IntPtr gm;
    if (!vars.Helper.TryRead<IntPtr>(out gm, vars.CutsceneSystem))
    {
        vars.CutsceneSystem = vars.FindCutscene("WBP_Cutscene_C");
        vars.Helper["CutsceneName"] = vars.Helper.Make<ulong>(vars.CutsceneSystem, 0x460);
        vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
    }

    var world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World) vars.Log("World: " + current.World);

    var level = vars.FNameToString(current.LoadedLevel);
	if (!string.IsNullOrEmpty(level) && level != "None") current.Level = level;
    if (old.Level != current.Level) vars.Log("Level: " + current.Level);

    var cutscene = vars.FNameToString(current.CutsceneName);
	if (!string.IsNullOrEmpty(cutscene)) current.Cutscene = cutscene;
    if (old.Cutscene != current.Cutscene) vars.Log("Cutscene: " + current.Cutscene);

    if (old.Pause != current.Pause) vars.Log("Pause: " + current.Pause);
    if (old.isLoading != current.isLoading) vars.Log("isLoading: " + current.isLoading);
}

start
{
    return old.Cutscene == "LS_SC0101_L1_M" && current.Cutscene != "LS_SC0101_L1_M";

}

onStart
{
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.World == "NoceEntry" || current.bWaitForRevive || !current.IsGameInitialized || current.isLoading;
}