state("CRToiPrototype-Win64-Shipping") {}


startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara8")).CreateInstance("Main");
	vars.Helper.GameName = "Crisol: Theatre of Idols Demo";
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

	var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18); // GWorld.FName
	vars.Helper["Demo_SGFStarted"] = vars.Helper.Make<bool>(gEngine, 0x11F8, 0xA89); 
	vars.Helper["DemoEndSplit"] = vars.Helper.Make<ulong>(Events.FunctionFlag("CR_OpenDoor_BP_C", "CRUnlockable_DoorShop_C*", "StartAnimation"));

    current.World = "";
}

update
{
    vars.Helper.Update();
	vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
	if (old.World != current.World)vars.Log("World: " + current.World);
	if (old.Demo_SGFStarted != current.Demo_SGFStarted) vars.Log("Demo_SGFStarted: " + current.Demo_SGFStarted);
	if (old.DemoEndSplit != current.DemoEndSplit) vars.Log("DemoEndSplit: " + current.DemoEndSplit);
}

start
{
	return current.World == "01_Chapter01_BlockingWP_LIB1" && old.Demo_SGFStarted == true && current.Demo_SGFStarted == false;
}

split
{
	if (old.DemoEndSplit != current.DemoEndSplit && current.DemoEndSplit != 0)
	{
		return true;
	}
}
