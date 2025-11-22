state("Rocky Horror"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "The Rocky Horror Show Video Game";
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ "1", true, "Brad", null },
        { "2", true, "Janet", null },
        { "3", true, "Dr. Scott", null },
        { "End", true, "End Game", null },

	};
	vars.Helper.Settings.Create(_settings);
	// vars.Helper.AlertRealTime();
	vars.CompletedSplits = new List<string>();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
        vars.Helper["MovementPlayerState"] = mono.Make<int>("PlayerMovement", "instance", "currentState");
        vars.Helper["Chapter"] = mono.Make<int>("RockyHorrorStory", "currentChapter");
        vars.Helper["currentCharacterName"] = mono.MakeString("RockyHorrorStory", "currentCharacterName");
		
		return true;
	});

	current.activeScene = "";
    current.loadingScene = "";
    current.Chapter = 0;
    current.currentCharacterName = "";
}

start
{
    return current.activeScene == "Courtyard" && old.MovementPlayerState == 5 && current.MovementPlayerState == 0;
}

onStart
{
	vars.CompletedSplits.Clear();
}

update
{
    if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Active.Name))	current.activeScene = vars.Helper.Scenes.Active.Name;
	if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Loaded[0].Name))	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name;

	if(current.activeScene != old.activeScene) vars.Log("active: Old: \"" + old.activeScene + "\", Current: \"" + current.activeScene + "\"");
	if(current.loadingScene != old.loadingScene) vars.Log("loading: Old: \"" + old.loadingScene + "\", Current: \"" + current.loadingScene + "\"");

    if (old.Chapter != current.Chapter) vars.Log("Current Chapter: " + current.Chapter);
    if (old.currentCharacterName != current.currentCharacterName) vars.Log("Current Character: " + current.currentCharacterName);
}

split
{
    if (old.Chapter != current.Chapter && settings[current.Chapter.ToString()] && !vars.CompletedSplits.Contains(current.Chapter.ToString()))
    {
        vars.CompletedSplits.Add(current.Chapter.ToString());
        if (settings[current.Chapter.ToString()]) return true;
    }
}
