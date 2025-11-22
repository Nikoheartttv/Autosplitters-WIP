state("SonicRacingCrossWorldsSteam") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.GameName = "Sonic Racing: CrossWorlds Demo";
    vars.Helper.AlertLoadless();
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
	IntPtr fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");

	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
	{
		const string Msg = "Not all required addresses could be found by scanning.";
		throw new Exception(Msg);
	}

	// if (gEngine == IntPtr.Zero)
	// {
	// 	const string Msg = "Not all required addresses could be found by scanning.";
	// 	throw new Exception(Msg);
	// }

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

    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18); // GWorld.FName
	// vars.Helper["???"] = vars.Helper.Make<???>(gEngine, 0x10A8, )
	// // GEngine -> BP_UnionGameInstance_C ->
	// GEngine -> BP_UnionGameInstance_C -> 0x38 , 0x0, 0x30, -> 
	// RaceInputReceiver (0xA40) -> 
	// 	UnionRacerStatusObject (0x400) ->
	// 		CurrentLapCount (0x2CC) [0 before passing start line, 1 after passing start line first time, 2 after passing start line second time]
	// 		bInGoal (0x2E7)
	vars.Helper["RaceTime"] = vars.Helper.Make<float>(gWorld, 0x30, 0xA0, 0x68, 0x410, 0x78, 0x28);
	vars.Helper["RaceTime"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	vars.Helper["StageId"] = vars.Helper.Make<byte>(gWorld, 0x30, 0xA0, 0x68, 0x408, 0x979);
	vars.Helper["StageId"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
 
    current.World = "";
	current.StageId = 0;
}

update
{
    vars.Helper.Update();
	vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
	if (old.World != current.World)vars.Log("World: " + current.World);
	if (old.StageId != current.StageId)vars.Log("StageId: " + current.StageId);
	// if (old.RaceTime != current.RaceTime) vars.Log("Time: " + current.RaceTime);
}

gameTime
{
	return TimeSpan.FromSeconds(current.RaceTime);
}

isLoading
{
	return true;
}

