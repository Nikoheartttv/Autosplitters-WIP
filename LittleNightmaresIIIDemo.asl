state("LittleNightmaresIII") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Little Nightmares III Demo";
    vars.Helper.AlertLoadless();
}

init
{
    if (vars.Helper.Reject(311296)) // memory size of splash/intro
        return; // safely abort init until main game loads

    vars.Log("Main game detected, running init...");

    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B ?? ?? ?? ?? ?? 48 85 C0 74 52");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B ?? ?? ?? ?? ?? 48 85 DB 74 2D");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D ?? ?? ?? ?? ?? E8 ?? ?? ?? ?? C6 05");

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
        throw new Exception("Required addresses not found.");

    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    vars.Helper["GameState"] = vars.Helper.Make<byte>(gEngine, 0xD28, 0x1A8);
    // Splash = 1, TitleScreen = 2, Legals = 3, MainMenu = 4, InGame = 5, PauseMenu = 6
    vars.Helper["ReplicatedWorldTimeSeconds"] = vars.Helper.Make<float>(gWorld, 0x30, 0x98, 0x30, 0x24C);

    // FName -> string converter
    vars.FNameToString = (Func<ulong, bool, string>)((fName, includeNumber) =>
    {
        var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);

        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return includeNumber && number != 0 ? name + "_" + number : name;
    });

    current.World = "None";
    
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    var world = vars.FNameToString(current.GWorldName, false);
    if (!string.IsNullOrEmpty(world) && world != "None")
        current.World = world;

    if (old.World != current.World)
        vars.Log("World: " + current.World);
}

start
{
    return old.GameState == 4 && current.GameState == 5;
}

split
{
    // Optional: add autosplit triggers here
}

isLoading
{
    return current.GameState == 6;
}
