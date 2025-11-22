state("The Seance of Blake Manor"){}

startup
{
	vars.Log = (Action<object>)(output => print("[Sorry We're Closed] " + output));
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Sorry We're Closed";
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ "Splits", true, "Splits", null },
	};

	vars.Helper.Settings.Create(_settings);
	vars.Helper.AlertLoadless();
	vars.CompletedSplits = new List<string>();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		// vars.Helper["isMainMenu"] = mono.Make<bool>("GameManager", "inst", "isMainMenu");

		return true;
	});

    current.activeScene = "";
    current.loadingScene = "";
}

onStart
{
    timer.IsGameTimePaused = true;
}

start
{
    return old.activeScene == "StartScreen" && current.activeScene == "Loading";
}

update
{
	if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Active.Name))	current.activeScene = vars.Helper.Scenes.Active.Name;
	if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Loaded[0].Name))	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name;

	if(current.activeScene != old.activeScene) vars.Log("active: Old: \"" + old.activeScene + "\", Current: \"" + current.activeScene + "\"");
	if(current.loadingScene != old.loadingScene) vars.Log("loading: Old: \"" + old.loadingScene + "\", Current: \"" + current.loadingScene + "\"");

}

isLoading
{
    return current.activeScene == "Loading" || current.activeScene == "IntroVideo" || current.activeScene == "ChapterBreak";
}