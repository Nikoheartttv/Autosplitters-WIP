state("Midnight-Win64-Shipping") {}

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
	};
	vars.Helper.Settings.Create(_settings);

	vars.CompletedSplits = new HashSet<string>();
}

init
{
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr Test = Events.InstancePtr("InputPlatformSettings", "InputPlatformSettings_Windows");
}