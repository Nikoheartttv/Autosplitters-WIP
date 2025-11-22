state("BabySteps") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Baby Steps";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var m = mono["CoreGameLogic", "Menu"];
        var pm = mono["CoreGameLogic", "PlayerMovement"];
        var sg = mono["CoreGameLogic", "SkipGame"];
        vars.Helper["gameInProgress"] = m.Make<bool>("me", "gameInProgress");
        vars.Helper["menuLoading"] = m.Make<bool>("me", "loading");
        vars.Helper["menuInCutscene"] = m.Make<bool>("me", "inCutscene");
        vars.Helper["menuInNonInteractiveCutscene"] = m.Make<bool>("me", "inNonInteractiveCutscene");
        vars.Helper["menuPaused"] = m.Make<bool>("me", "paused");
        vars.Helper["menuGameInProgress"] = m.Make<bool>("me", "gameInProgress");
        vars.Helper["pos"] = pm.Make<Vector3f>("pos");
        vars.Helper["endOfDemo"] = sg.Make<bool>("me", "endOfDemo");
        vars.Helper["menuCurChapter"] = m.Make<int>("me", "curChapter");
        vars.Helper["menuPlayingIntro"] = m.Make<bool>("me", "playingIntro");

        return true;
    });

    current.activeScene = "";
}

start
{
    return old.menuPlayingIntro == false && current.menuPlayingIntro == true;
    // return old.menuGameInProgress == false && current.menuGameInProgress == true;
}

update
{
    // if (current.pos.X != old.pos.X) vars.Log("X: " + current.pos.X);
    // if (current.pos.Y != old.pos.Y) vars.Log("Y: " + current.pos.Y);
    // if (current.pos.Z != old.pos.Z) vars.Log("Z: " + current.pos.Z);
}

split
{
    return old.menuCurChapter != current.menuCurChapter;
}

isLoading
{
    return current.menuLoading;
    // return current.menuLoading || current.menuInCutscene || current.menuPaused || current.menuInNonInteractiveCutscene;
}