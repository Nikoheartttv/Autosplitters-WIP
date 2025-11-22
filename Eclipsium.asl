state("Eclipsium") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
	vars.Helper.GameName = "Eclipsium";
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ "Splits", true, "Splits", null },
			{ "SaveStateType", true, "Main Splits - Upon Entry", "Splits"},
				{ "111752098", true, "Quarry", "SaveStateType" },
				{ "1473883822", true, "Upper Mines", "SaveStateType" },
				{ "69377319", true, "Lower Mines", "SaveStateType" },
				{ "286512350", true, "Maggot Mines 1", "SaveStateType" },
				{ "1136824394", true, "Planetarium", "SaveStateType" },
				{ "1393106438", true, "Dark Exit", "SaveStateType" },
				{ "889331330", true, "Village Beginning", "SaveStateType" },
				{ "1144345304", true, "Eye Cave", "SaveStateType" },
				{ "515874996", true, "Burning Witch", "SaveStateType" },
				{ "374206037", true, "Pig Church Exterior", "SaveStateType" },
				{ "1256899263", true, "Pig Church Interior", "SaveStateType" },
				{ "939593684", true, "Pig Church Underground", "SaveStateType" },
				{ "1899550682", true, "Pig Church Interior After Underground", "SaveStateType" },
				{ "1823360638", true, "Burning Pig Church Inverted", "SaveStateType" },
				{ "1992176344", true, "Submarines", "SaveStateType" },
				{ "1880656321", true, "Nuke", "SaveStateType" },
				{ "1957873737", true, "Beach", "SaveStateType" },
				{ "1314478214", true, "Tentacle Door", "SaveStateType" },
				{ "323201649", true, "Recursive Moon", "SaveStateType" },
				{ "169980023", true, "Throne Room", "SaveStateType" },
				{ "1337900448", true, "Halo", "SaveStateType" },
				{ "HaloFinalCutscene", true, "Halo Final Cutscene)", "SaveStateType" },
			{ "Hand", false, "Hand Unlock Splits", "Splits" },
				{ "Axe", true, "Axe Unlock Splits", "Hand" },
				{ "Fire", true, "Fire Unlock Splits", "Hand" },
				{ "Visor", true, "Visor Unlock Splits", "Hand" }
	};
	vars.Helper.Settings.Create(_settings);
	vars.CompletedSplits = new List<string>();

	vars.Helper.AlertLoadless();
}

init
{
	var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
    var CC = Instance.Get("CutsceneController", "isPlaying");

	vars.Helper["CutscenePlaying"] = vars.Helper.Make<bool>(CC.Base, CC.Offsets);
	vars.Helper["CutscenePlaying"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => 
	{	
		vars.Mono = mono;
        vars.Assembly = mono.Images["Assembly-CSharp"];
		return true;
	});

	vars.GameClassesLoaded = false;

	current.activeScene = "";
	current.loadingScene = "";
	current.currentSaveStateType = 0;
	current.AxeUnlocked = false;
	current.FireUnlocked = false;
	current.VisorUnlocked = false;
	current.Cutscene = false;
	current.HandUnlock = new List<IntPtr>();
}

start
{
	return old.activeScene == "MainMenu" && current.activeScene == "GlobalLevel";
}

onStart
{
	vars.CompletedSplits.Clear();
}

update
{
	vars.Helper.Update();
    vars.Helper.MapPointers();

	if (!vars.GameClassesLoaded && current.activeScene == "GlobalLevel")
    {
		var HMC = vars.Assembly["HandMenuController"];
		var RM = vars.Assembly["RespawnManager"];
		if (HMC.Static != IntPtr.Zero || RM.Static != IntPtr.Zero)
		{
			vars.Log("I got here");
			
			vars.Helper["HandUnlock"] = HMC.MakeList<IntPtr>("instance", "menuOptions");
			vars.Helper["currentSaveStateType"] = RM.Make<int>("_instance", "currentSaveStateType");
			current.HandUnlock = vars.Helper["HandUnlock"].Current;
			vars.GameClassesLoaded = true;
		}

	}

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

	if(!String.IsNullOrWhiteSpace(vars.Helper.Scenes.Active.Name))	current.activeScene = vars.Helper.Scenes.Active.Name;
	if(current.activeScene != old.activeScene) vars.Log("active: Old: \"" + old.activeScene + "\", Current: \"" + current.activeScene + "\"");

	if (old.currentSaveStateType != current.currentSaveStateType) vars.Log("currentSaveStateType: " + current.currentSaveStateType);
}

split
{
	if (current.currentSaveStateType != 0)
	{
		if (settings[current.currentSaveStateType.ToString()] && old.currentSaveStateType != current.currentSaveStateType && !vars.CompletedSplits.Contains(current.currentSaveStateType.ToString()))
		{
			vars.CompletedSplits.Add(current.currentSaveStateType.ToString());
			vars.Log("Split: " + current.currentSaveStateType.ToString());
			return true;
		}
	}

	if (settings["HaloFinalCutscene"] && current.currentSaveStateType == 1337900448 && old.CutscenePlaying == false && current.CutscenePlaying == true && !vars.CompletedSplits.Contains("HaloFinalCutscene"))
	{
		vars.CompletedSplits.Add("HaloFinalCutscene");
		vars.Log("Split: Halo Final Cutscene");
		return true;
	}

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