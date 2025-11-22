state("Eclipsium") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
	vars.Helper.GameName = "Eclipsium";
	// vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ "Splits", true, "Splits", null },
			{ "Hand", true, "Hand Unlock Splits", "Splits" },
				{ "Axe", true, "Axe Unlock Splits", "Splits" },
				{ "Fire", true, "Fire Unlock Splits", "Splits" },
				{ "Visor", true, "Visor Unlock Splits", "Splits" }
	};
	vars.Helper.Settings.Create(_settings);
	vars.CompletedSplits = new List<string>();

	vars.Helper.AlertLoadless();
}

init
{
	var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
    var CC = Instance.Get("CutsceneController", "isPlaying");
	var HMCHand = Instance.Get("HandMenuController", "menuOptions");
	
	vars.Helper["HandUnlock"] = vars.Helper.MakeList<IntPtr>(HMCHand.Base, HMCHand.Offsets);
	vars.Helper["CutscenePlaying"] = vars.Helper.Make<bool>(CC.Base, CC.Offsets);

	current.AxeUnlocked = false;
	current.FireUnlocked = false;
	current.VisorUnlocked = false;
	current.Cutscene = false;
	current.HandUnlock = new List<IntPtr>();
}

start
{
	// return old.activeScene == "MainMenu" && current.activeScene == "GlobalLevel";
}

onStart
{
	vars.CompletedSplits.Clear();
}

update
{
	vars.Helper.Update();
    vars.Helper.MapPointers();
	
	vars.Log(current.CutscenePlaying.ToString());
	if (old.HandUnlock.Count != current.HandUnlock.Count) vars.Log("HandUnlockCount: " + current.HandUnlock.Count);

	for (int i = 0; i < current.HandUnlock.Count; i++) 
	{
		bool enabled = vars.Helper.Read<bool>(current.HandUnlock[i] + 0x10); 
		int option = vars.Helper.Read<byte>(current.HandUnlock[i] + 0x1C);

		if (option == 1 && enabled)
		{
			current.AxeUnlocked = true;
		}
		else if (option == 2 && enabled && current.VisorUnlocked == true)
		{
			current.FireUnlocked = true;
		}
		else if (option == 3 && enabled && current.AxeUnlocked == true)
		{
			current.VisorUnlocked = true;
		}
	}

	// if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Active.Name))	current.activeScene = vars.Helper.Scenes.Active.Name;
	// if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Loaded[0].Name))	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name;

	// if(current.activeScene != old.activeScene) vars.Log("active: Old: \"" + old.activeScene + "\", Current: \"" + current.activeScene + "\"");
	// if(current.loadingScene != old.loadingScene) vars.Log("loading: Old: \"" + old.loadingScene + "\", Current: \"" + current.loadingScene + "\"");
}

split
{
    if (settings["Axe"] && current.AxeUnlocked == true && !vars.CompletedSplits.Contains("Axe"))
    {
		vars.CompletedSplits.Add("Axe");
		vars.Log("Split: Axe Unlocked");
        return true;
    }

    if (settings["Fire"] && current.FireUnlocked == true && !vars.CompletedSplits.Contains("Fire"))
    {
		vars.CompletedSplits.Add("Fire");
		vars.Log("Split: Fire Unlocked");
        return true;
    }

    if (settings["Visor"] && current.VisorUnlocked == true && !vars.CompletedSplits.Contains("Visor"))
    {
		vars.CompletedSplits.Add("Visor");
		vars.Log("Split: Visor Unlocked");
        return true;
    }
}

isLoading
{
	return current.CutscenePlaying;
}