state("Midnight-Win64-Shipping") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr Test = Events.InstancePtr("InputPlatformSettings", "InputPlatformSettings_Windows");
}