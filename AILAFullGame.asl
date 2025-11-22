state("ProjectAIDA-Win64-Shipping") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.AlertLoadless();
    vars.Uhara.EnableDebug();
}

init
{
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	if (vars.Utils.GEngine != IntPtr.Zero) vars.Uhara.Log("GEngine: " + vars.Utils.GEngine.ToString("X"));
	if (vars.Utils.GWorld != IntPtr.Zero) vars.Uhara.Log("GWorld: " + vars.Utils.GWorld.ToString("X"));
	if (vars.Utils.FNames != IntPtr.Zero) vars.Uhara.Log("FNames: " + vars.Utils.FNames.ToString("X"));

	vars.Resolver.Watch<uint>("GWorldName", vars.Utils.GWorld, 0x18);
    vars.Resolver.Watch<ulong>("PrologueStart", vars.Events.FunctionFlag("LS_Prologue_Start_DirectorBP_C", "LS_Prologue_Start_DirectorBP_C", "SequenceEvent__ENTRYPOINTLS_Prologue_Start_DirectorBP"));

	
	current.World = "";

}

start
{
    // return current.World == "Map_DemoImpossibleHouse" && old.TransitionType == 1 && current.TransitionType == 0;
    // return (old.World == "Map_MainMenuDemo" || old.World == "Map_MainMenu") && current.World == "Map_DemoImpossibleHouse";
    if (old.PrologueStart != current.PrologueStart && current.PrologueStart != 0)
    {
        vars.Uhara.Log("Prologue Start detected.");
        return true;
    }
}

update
{
    vars.Uhara.Update();

	var world = vars.Utils.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
	if (old.World != current.World) vars.Uhara.Log("World: " + current.World);
}