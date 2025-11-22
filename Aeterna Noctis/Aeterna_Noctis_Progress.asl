state("Aeterna Noctis") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Aeterna Noctis";
    vars.Helper.LoadSceneManager = true;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        // vars.Helper["powerFragments"] = mono.Make<int>("ProgressController", "Progress", "powerFragments");
        // vars.Helper["bossesDefeated"] = mono.Make<int>("ProgressController", "Progress", "bossesDefeated");
        // vars.Helper["templeOfKingsKeysOwned"] = mono.Make<int>("ProgressController", "Progress", "templeOfKingsKeysOwned");
        // vars.Helper["bronzeChestsOpened"] = mono.Make<int>("ProgressController", "Progress", "bronzeChestsOpened");
        // vars.Helper["ironChestsOpened"] = mono.Make<int>("ProgressController", "Progress", "ironChestsOpened");
        // vars.Helper["goldChestsOpened"] = mono.Make<int>("ProgressController", "Progress", "goldChestsOpened");
        // vars.Helper["heartFragments"] = mono.Make<int>("ProgressController", "Progress", "heartFragments");
        // vars.Helper["skillPoints"] = mono.Make<int>("ProgressController", "Progress", "skillPoints");
        // vars.Helper["lorePoints1"] = mono.Make<int>("ProgressController", "Progress", "lorePoints1");
        // vars.Helper["lorePoints2"] = mono.Make<int>("ProgressController", "Progress", "lorePoints2");
        // vars.Helper["chroniclerDialogues"] = mono.Make<int>("ProgressController", "Progress", "chroniclerDialogues");
        // vars.Helper["asnurBuyableItems"] = mono.Make<int>("ProgressController", "Progress", "asnurBuyableItems");
        // vars.Helper["gems1"] = mono.Make<int>("ProgressController", "Progress", "gems1");
        // vars.Helper["kingWeapons"] = mono.Make<int>("ProgressController", "Progress", "kingWeapons");
        // vars.Helper["kingAbilities"] = mono.Make<int>("ProgressController", "Progress", "kingAbilities");
        // vars.Helper["wisemanFound"] = mono.Make<int>("ProgressController", "Progress", "wisemanFound");
        vars.Helper["heartPieces"] = mono.Make<int>("KingVariables", "_healthController", "_currentHeartPieces");
        vars.Helper["hearts"] = mono.Make<int>("KingVariables", "_healthController", "_currentHearts");
        // vars.Helper["healthHearts"] = mono.Make<int>("KingVariables", "_healthController", "_currentHealthHearts");
        

        return true;
    });

    // current.powerFragments = 0;
    // current.bossesDefeated = 0;
    // current.templeOfKingsKeysOwned = 0;
    // current.bronzeChestsOpened = 0;
    // current.ironChestsOpened = 0;
    // current.goldChestsOpened = 0;
    // current.heartFragments = 0;
    // current.skillPoints = 0;
    // current.lorePoints1 = 0;
    // current.lorePoints2 = 0;
    // current.chroniclerDialogues = 0;
    // current.asnurBuyableItems = 0;
    // current.gems1 = 0;
    // current.kingWeapons = 0;
    // current.kingAbilities = 0;
    // current.wisemanFound = 0;
    current.heartPieces = 0;
}

update
{
    // if (old.powerFragments != current.powerFragments) vars.Log("Power Fragments: " + current.powerFragments);
    // if (old.bossesDefeated != current.bossesDefeated) vars.Log("Bosses Defeated: " + current.bossesDefeated);
    // if (old.templeOfKingsKeysOwned != current.templeOfKingsKeysOwned) vars.Log("Temple of Kings Keys Owned: " + current.templeOfKingsKeysOwned);
    // if (old.bronzeChestsOpened != current.bronzeChestsOpened) vars.Log("Bronze Chests Opened: " + current.bronzeChestsOpened);
    // if (old.ironChestsOpened != current.ironChestsOpened) vars.Log("Iron Chests Opened: " + current.ironChestsOpened);
    // if (old.goldChestsOpened != current.goldChestsOpened) vars.Log("Gold Chests Opened: " + current.goldChestsOpened);
    // if (old.heartFragments != current.heartFragments) vars.Log("Heart Fragments: " + current.heartFragments);
    // if (old.skillPoints != current.skillPoints) vars.Log("Skill Points: " + current.skillPoints);
    // if (old.lorePoints1 != current.lorePoints1) vars.Log("Lore Points 1: " + current.lorePoints1);
    // if (old.lorePoints2 != current.lorePoints2) vars.Log("Lore Points 2: " + current.lorePoints2);
    // if (old.chroniclerDialogues != current.chroniclerDialogues) vars.Log("Chronicler Dialogues: " + current.chroniclerDialogues);
    // if (old.asnurBuyableItems != current.asnurBuyableItems) vars.Log("Asnur Buyable Items: " + current.asnurBuyableItems);
    // if (old.gems1 != current.gems1) vars.Log("Gems 1: " + current.gems1);
    // if (old.kingWeapons != current.kingWeapons) vars.Log("King Weapons: " + current.kingWeapons);
    // if (old.kingAbilities != current.kingAbilities) vars.Log("King Abilities: " + current.kingAbilities);
    // if (old.wisemanFound != current.wisemanFound) vars.Log("Wiseman Found: " + current.wisemanFound);

    if (old.heartPieces != current.heartPieces) vars.Log("Heart Pieces: " + current.heartPieces);
}

// count for chests is accurate