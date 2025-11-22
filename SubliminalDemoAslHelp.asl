state("Subliminal-Win64-Shipping") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.GameName = "Subliminal Demo";
	vars.Helper.AlertLoadless();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
	IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");

    if (gWorld != IntPtr.Zero) vars.Log("gWorld: " + gWorld.ToString("X"));
    if (gEngine != IntPtr.Zero) vars.Log("gEngine: " + gEngine.ToString("X"));
    if (fNames != IntPtr.Zero) vars.Log("fNames: " + fNames.ToString("X"));

    vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);

        int length   = vars.Helper.Read<short>(entry) >> 6;
        string name  = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);

    // GEngine -> GameInstance -> As Subliminal Character -> Game Paused
    vars.Helper["GamePaused"] = vars.Helper.Make<bool>(gEngine, 0x1248, 0x1D8, 0xDA8);

    vars.Helper["EmptySpaceStart"] = vars.Helper.Make<ulong>(vars.Events.FunctionFlag("BP_EmptySpace_Intro_C", "BP_EmptySpace_Intro_C", "Timeline__UpdateFunc"));
    vars.Helper["EndCardTrigger"] = vars.Helper.Make<ulong>(vars.Events.FunctionFlag("BP_EndcardTrigger_SNF_C", "BP_EndcardTrigger_SNF_C", "ExecuteUbergraph_BP_EndcardTrigger_SNF"));
    current.World = "";
    current.EmptySpaceStart = 0;
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName);
    if (world != null && world != "None") current.World = world;
    if (old.World != current.World) vars.Log("World: " + current.World);
}


start
{
    return old.EmptySpaceStart != current.EmptySpaceStart && current.EmptySpaceStart != 0;
    // return old.World == "EP1_NextFest_Persistent"
}

split
{
    if (old.EndCardTrigger != current.EndCardTrigger && current.EndCardTrigger != 0)
        return true;
}
    