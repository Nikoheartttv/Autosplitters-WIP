state("Total Chaos"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Total Chaos (Demo)";
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ "Splits", true, "Splits", null },
            { "Arrival", true, "Arrival", "Splits" },
            { "Decay", true, "Decay", "Splits" },
            { "DemoEnd", true, "End of Demo", "Splits" },
	};
	vars.Helper.Settings.Create(_settings);
	vars.Helper.AlertGameTime();
	vars.CompletedLevels = new List<string>();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => 
	{	
        vars.Helper["loadInProgress"] = mono.Make<bool>("GameState", "main", "loadInProgress");
        vars.Helper["endDemoTriggered"] = mono.Make<bool>("PlayerController", "main", "endDemoTriggered");
        vars.Helper["isAlive"] = mono.Make<bool>("PlayerController", "main", "isAlive");
        vars.Helper["cinematicLocked"] = mono.Make<bool>("PlayerController", "main", "cinematicLocked");
        vars.Helper["lockPlayer"] = mono.Make<bool>("PlayerController", "main", "lockPlayer");
        vars.Helper["gamePromptActive"] = mono.Make<bool>("PlayerController", "main", "gamePromptActive");
        vars.Helper["JournalTutorial"] = mono.Make<bool>("UiController", "main", "uiJournal", "showTutorial");

		return true;
	});
}

start
{
	return old.activeScene == "MainMenu" && current.activeScene == "Arrival";
}

onStart
{
	timer.IsGameTimePaused = true;
	vars.CompletedLevels.Clear();
}

update
{
	if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Active.Name))	current.activeScene = vars.Helper.Scenes.Active.Name;
	// if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Loaded[0].Name))	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name;

	if(current.activeScene != old.activeScene) vars.Log("active: Old: \"" + old.activeScene + "\", Current: \"" + current.activeScene + "\"");
	// if(current.loadingScene != old.loadingScene) vars.Log("loading: Old: \"" + old.loadingScene + "\", Current: \"" + current.loadingScene + "\"");
}

split
{
    if (old.activeScene != "MainMenu" && old.activeScene != current.activeScene && settings[old.activeScene] && !vars.CompletedLevels.Contains(old.activeScene))
		{
			vars.CompletedLevels.Add(old.activeScene);
			return true;
		}
    if (settings["DemoEnd"] && old.endDemoTriggered == false && current.endDemoTriggered) return true;
}

isLoading
{
	return current.loadInProgress || current.JournalTutorial || current.cinematicLocked || current.lockPlayer || !current.isAlive;
}