state("Leap Galaxy Demo") {

	int roomID : 0xCB7D28;
    double IGT : 0xCBB2C8, 0x30, 0x1E0, 0x10;
    bool hasWon : 0xCB79C0, 0x108, 0x208, 0x208, 0xE60;
    double resultsIGT : 0xCCB590, 0x340, 0x520;
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.GameName = "Leap Galaxy Demo";
	vars.Helper.AlertLoadless();

	dynamic[,] _settings =
	{
		{ "Spaceship", true, "Spaceship", null },
			{ "3", true, "1 - The Basics", "Spaceship"},
			{ "134", true, "2 - Hoops And Jumps", "Spaceship" },
			{ "5", true, "3 - Shooting Stars", "Spaceship" },
			{ "135", true, "4 - Quick Star(t)", "Spaceship" },
			{ "136", true, "5 - Locked In", "Spaceship" },
			{ "6", true, "6 - Speeding Up", "Spaceship" },
			{ "7", true, "7 - Higher Places", "Spaceship" },
	};
	vars.Helper.Settings.Create(_settings);
}

onStart
{
    timer.IsGameTimePaused = true;
}

start
{
    if (old.roomID == 1 && current.roomID != 1) return true;
}

split
{
    if (current.roomID != 1)
    {
        if (settings[current.roomID.ToString()] && old.hasWon == false && current.hasWon == true) return true;
    }
}

update
{
    if (old.hasWon != current.hasWon) vars.Log("hasWon: " + current.hasWon);
}

isLoading
{
    return current.IGT == 0;
}