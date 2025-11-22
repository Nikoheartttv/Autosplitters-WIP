state("Aeterna Noctis")
{
}

startup
{
    vars.queuedSplits = 0;
    vars.maxProgress = 517;
    vars.Log = (Action<object>)(value => print("[Aeterna Noctis] " + value));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true;

    dynamic[,] settingsArray =
    {
        { "Settings", true, "Settings", null, null },
            { "UseDevTime", true, "Use the game's built-in clock to measure IGT", "Settings", null },
            { "CutSceneStop", true, "Stop the timer during cutscenes", "Settings", null },
            { "PauseStop", true, "Stop the timer when the game is paused", "Settings", null },
        { "Splits", false, "Splits", null, null },
            { "Bosses", false, "Bosses", "Splits", null },
                { "Devourer", true, "The Devourer (First Encounter)", "Bosses", 1 },
                { "Slime", true, "Giant Slime", "Bosses", 2 },
                { "Garibaldi", true, "Garibaldi (not currently working; Use Quest \"The Graveyard Master\" stage 4)", "Bosses", 4 },
                { "Sword", true, "The Sword", "Bosses", 8 },
                { "Emperor", true, "The Emperor (not currently working; Use Quest \"For the Glory of the Emperor\" stage 7)", "Bosses", 16 },
                { "Phoenix", true, "The Phoenix", "Bosses", 32 },
                { "Wormorok", true, "Wormorok", "Bosses", 64 },
                { "Robot", true, "Battle-Bot T-900", "Bosses", 128 },
                { "Beholder", true, "The Beholder", "Bosses", 256 },
                { "AI", true, "The Mastermind", "Bosses", 512 },
                { "KingClone", true, "The Raging Soul", "Bosses", 1024 },
                //{ "Sage", true, "The Sage? (not currently working)", "Bosses", 2048 },
                { "Chaos", true, "Flight from Chaos (not currently working; Use scene \"Escape from Chaos\")", "Bosses", 4096 },
                { "General", true, "High Aurora", "Bosses", 8192 },
                { "Queen", true, "The Queen (not currently working)", "Bosses", 16384 },
                { "RobotV2", true, "Battle-Bot T-900 (advanced)", "Bosses", 32768 },
                { "AIV2", true, "The Mastermind (advanced)", "Bosses", 65536 },
            { "Scenes", true, "Scenes", "Splits", null },
                { "StoryAnime2", true, "Escape from Chaos", "Scenes", null },
                { "FinalCredits", true, "Final Credits", "Scenes", null },
            { "Progress", true, "Progress", "Splits", null },
                { "Abilities", false, "Abilities", "Progress", null },
                    { "Dash", false, "Dash", "Abilities", 1 },
                    { "BloodGem", false, "Blood Gem", "Abilities", 2 },
                    { "Claw", false, "Claw", "Abilities", 4 },
                    { "DoubleJump", false, "Double Jump", "Abilities", 8 },
                    { "Darkness", false, "Darkness", "Abilities", 16 },
                    { "DarkShield", false, "DarkShield", "Abilities", 32 },
                    { "DarkPortal", false, "DarkPortal", "Abilities", 64 },
                { "Weapons", false, "Weapons", "Progress", null },
                    { "Axe", false, "Wild Blade (Axe)", "Weapons", 1 },
                    { "Scythe", false, "Bloodthirsty Scythe", "Weapons", 2 },
                    { "LightArrow", false, "Light Arrow", "Weapons", 4 },
                    { "Spear", false, "Spear of Cycles", "Weapons", 8 },
                    { "Shuriken", false, "Blood Shuriken", "Weapons", 16 },
                    { "KatanaSlash", false, "Edge of the Master (Katana)", "Weapons", 32 },
                    { "KatanaFeint", false, "Master Technique (Katana Feint)", "Weapons", 64 },
                { "Completion", false, "Completion (N.B. Turn off Reset if aiming for 100%)", "Progress", null },
                    { "1%", false, "1%", "Completion", 5 },
                    { "10%", false, "10%", "Completion", 52 },
                    { "20%", false, "20%", "Completion", 104 },
                    { "30%", false, "30%", "Completion", 156 },
                    { "40%", false, "40%", "Completion", 207 },
                    { "50%", false, "50%", "Completion", 259 },
                    { "60%", false, "60%", "Completion", 311 },
                    { "70%", false, "70%", "Completion", 362 },
                    { "80%", false, "80%", "Completion", 414 },
                    { "90%", false, "90%", "Completion", 466 },
                    { "100%", false, "100%", "Completion", 517 },
            { "Quests", false, "Quests", "Splits", null },
                { "Quest0", false, "The Graveyard Master", "Quests", 0 },
                    { "Quest0_1", false, "[Quest Start] Find out the master's name", "Quest0", 1 },
                    { "Quest0_2", false, "Speak with Garibaldi", "Quest0", 2 },
                    { "Quest0_3", false, "Destroy Garibaldi", "Quest0", 3 },
                    { "Quest0_4", false, "One last chatter", "Quest0", 4 },
                    { "Quest0_5", false, "[Quest Complete] Mission completed", "Quest0", 5 },
                { "Quest1", false, "The Cursed Crypt", "Quests", 1 },
                    { "Quest1_1", false, "[Quest Start] First note acquired", "Quest1", 1 },
                    { "Quest1_2", false, "Second note acquired", "Quest1", 2 },
                    { "Quest1_3", false, "Third note acquired", "Quest1", 3 },
                    { "Quest1_4", false, "Fourth note acquired", "Quest1", 4 },
                    { "Quest1_5", false, "Fifth note acquired", "Quest1", 5 },
                    { "Quest1_6", false, "Sixth note acquired", "Quest1", 6 },
                    { "Quest1_7", false, "Seventh note acquired", "Quest1", 7 },
                    { "Quest1_8", false, "Eighth note acquired", "Quest1", 8 },
                    { "Quest1_9", false, "Ninth note acquired", "Quest1", 9 },
                    { "Quest1_10", false, "Crypt key acquired", "Quest1", 10 },
                    { "Quest1_11", false, "[Quest Complete] Mission completed", "Quest1", 11 },
                { "Quest2", false, "The Collector's Art", "Quests", 2 },
                    { "Quest2_1", false, "[Quest Start] Find a Cavernous worm chrysalis", "Quest2", 1 },
                    { "Quest2_2", false, "Bring it to the Collector", "Quest2", 2 },
                    { "Quest2_3", false, "Get 50% of the index", "Quest2", 3 },
                    { "Quest2_4", false, "Return to the collector", "Quest2", 4 },
                    { "Quest2_5", false, "Free and defeat the creature from the lamp", "Quest2", 5 },
                    { "Quest2_6", false, "Return to the collector", "Quest2", 6 },
                    { "Quest2_7", false, "Get 70% of the index", "Quest2", 7 },
                    { "Quest2_8", false, "Return to the collector", "Quest2", 8 },
                    { "Quest2_9", false, "Find and defeat the slime", "Quest2", 9 },
                    { "Quest2_10", false, "Return to the collector", "Quest2", 10 },
                    { "Quest2_11", false, "Get 90% of the index", "Quest2", 11 },
                    { "Quest2_12", false, "Return to the collector", "Quest2", 12 },
                    { "Quest2_13", false, "Hunt for the celestial dragon", "Quest2", 13 },
                    { "Quest2_14", false, "Find the dragon again and retrieve its eye", "Quest2", 14 },
                    { "Quest2_15", false, "Return to the collector", "Quest2", 15 },
                    { "Quest2_16", false, "Get 100% of the index", "Quest2", 16 },
                    { "Quest2_17", false, "Return to the collector", "Quest2", 17 },
                    { "Quest2_18", false, "[Quest Complete] Mission completed", "Quest2", 18 },
                { "Quest3", false, "The Seven Fragments", "Quests", 3 },
                    { "Quest3_1", false, "[Quest Start] I must find the seven fragments", "Quest3", 1 },
                    { "Quest3_2", false, "A fragment is located at the top of the Tower of Light", "Quest3", 2 },
                    { "Quest3_3", false, "First fragment acquired", "Quest3", 3 },
                    { "Quest3_4", false, "Second fragment acquired", "Quest3", 4 },
                    { "Quest3_5", false, "Third fragment acquired", "Quest3", 5 },
                    { "Quest3_6", false, "Fourth fragment acquired", "Quest3", 6 },
                    { "Quest3_7", false, "Fifth fragment acquired", "Quest3", 7 },
                    { "Quest3_8", false, "Sixth fragment acquired", "Quest3", 8 },
                    { "Quest3_9", false, "Seventh fragment acquired", "Quest3", 9 },
                    { "Quest3_10", false, "[Quest Complete] Mission completed", "Quest3", 10 },
                { "Quest4", false, "A New Cycle", "Quests", 4 },
                    { "Quest4_1", false, "[Quest Start] Complete the basic training", "Quest4", 1 },
                    { "Quest4_2", false, "Meet the keeper", "Quest4", 2 },
                    { "Quest4_3", false, "Keeper has more instructions", "Quest4", 3 },
                    { "Quest4_4", false, "Meet an old acquaintance", "Quest4", 4 },
                    { "Quest4_5", false, "Pass the first gate", "Quest4", 5 },
                    { "Quest4_6", false, "Return to the keeper", "Quest4", 6 },
                    { "Quest4_7", false, "Return to the wasteland", "Quest4", 7 },
                    { "Quest4_8", false, "[Quest Complete] Mission completed", "Quest4", 8 },
                { "Quest5", false, "The Temple Trials", "Quests", 5 },
                    { "Quest5_1", false, "[Quest Start] There are 10 trials I must complete.", "Quest5", 1 },
                    { "Quest5_2", false, "First trial complete", "Quest5", 2 },
                    { "Quest5_3", false, "Second trial complete", "Quest5", 3 },
                    { "Quest5_4", false, "Third trial complete", "Quest5", 4 },
                    { "Quest5_5", false, "Fourth trial complete", "Quest5", 5 },
                    { "Quest5_6", false, "Fifth trial complete", "Quest5", 6 },
                    { "Quest5_7", false, "Sixth trial complete", "Quest5", 7 },
                    { "Quest5_8", false, "Seventh trial complete", "Quest5", 8 },
                    { "Quest5_9", false, "Eighth trial complete", "Quest5", 9 },
                    { "Quest5_10", false, "Ninth trial complete", "Quest5", 10 },
                    { "Quest5_11", false, "Tenth trial complete", "Quest5", 11 },
                    { "Quest5_12", false, "[Quest Complete] Mission completed", "Quest5", 12 },
                { "Quest6", false, "Escape from the Wasteland", "Quests", 6 },
                    { "Quest6_1", false, "[Quest Start] Go east", "Quest6", 1 },
                    { "Quest6_2", false, "Reach the wall", "Quest6", 2 },
                    { "Quest6_3", false, "Key acquired", "Quest6", 3 },
                    { "Quest6_4", false, "The path is clear", "Quest6", 4 },
                    { "Quest6_5", false, "Blood gem found", "Quest6", 5 },
                    { "Quest6_6", false, "[Quest Complete] Mission completed", "Quest6", 6 },
                { "Quest7", false, "Cross the Graveyard", "Quests", 7 },
                    { "Quest7_1", false, "[Quest Start] Cross to the other side of the cemetary", "Quest7", 1 },
                    { "Quest7_2", false, "Crypt key acquired", "Quest7", 2 },
                    { "Quest7_3", false, "Closer to the exit", "Quest7", 3 },
                    { "Quest7_4", false, "Reached the other side", "Quest7", 4 },
                    { "Quest7_5", false, "[Quest Complete] Mission completed", "Quest7", 5 },
                { "Quest8", false, "A Bloodthirsty Weapon", "Quests", 8 },
                    { "Quest8_1", false, "[Quest Start] Find the weapon", "Quest8", 1 },
                    { "Quest8_2", false, "[Quest Complete] Mission completed", "Quest8", 2 },
                { "Quest9", false, "The Cult of the Molten Anvil", "Quests", 9 },
                    { "Quest9_1", false, "[Quest Start] A damsel awaits me", "Quest9", 1 },
                    { "Quest9_2", false, "Turn off the three forges", "Quest9", 2 },
                    { "Quest9_3", false, "First forge turned off", "Quest9", 3 },
                    { "Quest9_4", false, "Second forge turned off", "Quest9", 4 },
                    { "Quest9_5", false, "Third forge turned off", "Quest9", 5 },
                    { "Quest9_6", false, "Reach the master's chamber", "Quest9", 6 },
                    { "Quest9_7", false, "Defeat the master", "Quest9", 7 },
                    { "Quest9_8", false, "Master defeated, inform the damsel", "Quest9", 8 },
                    { "Quest9_9", false, "[Quest Complete] Mission completed", "Quest9", 9 },
                { "Quest10", false, "The Goblin Gold", "Quests", 10 },
                    { "Quest10_1", false, "[Quest Start] Open the path to the ancient goblin village", "Quest10", 1 },
                    { "Quest10_2", false, "Go to the goblin king for a reward", "Quest10", 2 },
                    { "Quest10_3", false, "Retrieve a potion from the collector", "Quest10", 3 },
                    { "Quest10_4", false, "Return to the goblin king", "Quest10", 4 },
                    { "Quest10_5", false, "Retrieve the royal scepter", "Quest10", 5 },
                    { "Quest10_6", false, "Return to the goblin king", "Quest10", 6 },
                    { "Quest10_7", false, "Go collect your reward", "Quest10", 7 },
                    { "Quest10_8", false, "Defeat the hordes", "Quest10", 8 },
                    { "Quest10_9", false, "[Quest Complete] Mission completed", "Quest10", 9 },
                { "Quest11", false, "For the Glory of the Emperor", "Quests", 11 },
                    { "Quest11_1", false, "[Quest Start] Gather the seals", "Quest11", 1 },
                    { "Quest11_2", false, "First seal acquired", "Quest11", 2 },
                    { "Quest11_3", false, "Second seal acquired", "Quest11", 3 },
                    { "Quest11_4", false, "Third seal acquired", "Quest11", 4 },
                    { "Quest11_5", false, "Fourth seal acquired", "Quest11", 5 },
                    { "Quest11_6", false, "Defeat the Emperor", "Quest11", 6 },
                    { "Quest11_7", false, "[Quest Complete] Mission completed", "Quest11", 7 },
                { "Quest12", false, "Finish what you Started", "Quests", 12 },
                    { "Quest12_1", false, "[Quest Start] There is no turning back", "Quest12", 1 },
                    { "Quest12_2", false, "Retrieve the Chaos Crystal", "Quest12", 2 },
                    { "Quest12_3", false, "Return to the Oracle", "Quest12", 3 },
                    { "Quest12_4", false, "Recharge the crystal", "Quest12", 4 },
                    { "Quest12_5", false, "Return to the Oracle", "Quest12", 5 },
                    { "Quest12_6", false, "Ascend to the heavens", "Quest12", 6 },
                    { "Quest12_7", false, "Enter the palace", "Quest12", 7 },
                    { "Quest12_8", false, "Reach the throne and defeat the queen", "Quest12", 8 },
                    { "Quest12_9", false, "The die is cast", "Quest12", 9 },
                    { "Quest12_10", false, "[Quest Complete] Mission completed", "Quest12", 10 },
                { "Quest13", false, "Crystal Elevator", "Quests", 13 },
                    { "Quest13_1", false, "[Quest Start] I must find all the gears", "Quest13", 1 },
                    { "Quest13_2", false, "First gear acquired", "Quest13", 2 },
                    { "Quest13_3", false, "Second gear acquired", "Quest13", 3 },
                    { "Quest13_4", false, "Third gear acquired", "Quest13", 4 },
                    { "Quest13_5", false, "[Quest Complete] Mission completed", "Quest13", 5 },
                { "Quest14", false, "I Machine", "Quests", 14 },
                    { "Quest14_1", false, "[Quest Start] Card key acquired", "Quest14", 1 },
                    { "Quest14_2", false, "Card recharged", "Quest14", 2 },
                    { "Quest14_3", false, "Keys updated", "Quest14", 3 },
                    { "Quest14_4", false, "Card Repaired", "Quest14", 4 },
                    { "Quest14_5", false, "[Quest Complete] Mission completed", "Quest14", 5 },
                { "Quest15", false, "The West Tower Chamber", "Quests", 15 },
                    { "Quest15_1", false, "[Quest Start] I need to access the tower chamber", "Quest15", 1 },
                    { "Quest15_2", false, "First key acquired", "Quest15", 2 },
                    { "Quest15_3", false, "Second key acquired", "Quest15", 3 },
                    { "Quest15_4", false, "Third key acquired", "Quest15", 4 },
                    { "Quest15_5", false, "Fourth key acquired", "Quest15", 5 },
                    { "Quest15_6", false, "Fifth key acquired", "Quest15", 6 },
                    { "Quest15_7", false, "Sixth key acquired", "Quest15", 7 },
                    { "Quest15_8", false, "[Quest Complete] Mission completed", "Quest15", 8 },
                { "Quest16", false, "The Soul Mirror", "Quests", 16 },
                    { "Quest16_1", false, "[Quest Start] The door is in Famished Town", "Quest16", 1 },
                    { "Quest16_2", false, "Return at least 10 fragments", "Quest16", 2 },
                    { "Quest16_3", false, "Return at least 20 fragments", "Quest16", 3 },
                    { "Quest16_4", false, "Return at least 29 fragments", "Quest16", 4 },
                    { "Quest16_5", false, "Return at least 38 fragments", "Quest16", 5 },
                    { "Quest16_6", false, "Return at least 46 fragments", "Quest16", 6 },
                    { "Quest16_7", false, "Return at least 54 fragments", "Quest16", 7 },
                    { "Quest16_8", false, "Return at least 61 fragments", "Quest16", 8 },
                    { "Quest16_9", false, "Return at least 66 fragments", "Quest16", 9 },
                    { "Quest16_10", false, "Return at least 71 fragments", "Quest16", 10 },
                    { "Quest16_11", false, "Return at least 75 fragments", "Quest16", 11 },
                    { "Quest16_12", false, "Speak to the Keeper", "Quest16", 12 },
                    { "Quest16_13", false, "[Quest Complete] Mission completed", "Quest16", 13 },
                { "Quest17", false, "Concert of the Night", "Quests", 17 },
                    { "Quest17_1", false, "[Quest Start] Retrieve and play music sheets", "Quest17", 1 },
                    { "Quest17_2", false, "First sheet acquired and played", "Quest17", 2 },
                    { "Quest17_3", false, "Second sheet acquired and playedd", "Quest17", 3 },
                    { "Quest17_4", false, "Third sheet acquired and played", "Quest17", 4 },
                    { "Quest17_5", false, "Fourth sheet acquired and played", "Quest17", 5 },
                    { "Quest17_6", false, "Fifth sheet acquired and played", "Quest17", 6 },
                    { "Quest17_7", false, "Sixth sheet acquired and played", "Quest17", 7 },
                    { "Quest17_8", false, "Seventh sheet acquired and played", "Quest17", 8 },
                    { "Quest17_9", false, "Eighth sheet acquired and played", "Quest17", 9 },
                    { "Quest17_10", false, "Ninth sheet acquired and played", "Quest17", 10 },
                    { "Quest17_11", false, "Tenth sheet acquired and played", "Quest17", 11 },
                    { "Quest17_12", false, "Eleventh sheet acquired and played", "Quest17", 12 },
                    { "Quest17_13", false, "All Sheets acquired and played", "Quest17", 13 },
                    { "Quest17_14", false, "[Quest Complete] Mission completed", "Quest17", 14 },
                { "Quest18", false, "A Peculiar Merchant", "Quests", 18 },
                    { "Quest18_1", false, "[Quest Start] Pay the merchant a visit", "Quest18", 1 },
                    { "Quest18_2", false, "Find the merchant's key", "Quest18", 2 },
                    { "Quest18_3", false, "Return to the merchant", "Quest18", 3 },
                    { "Quest18_4", false, "[Quest Complete] Mission completed", "Quest18", 4 },
                { "Quest19", false, "A Cursed Land", "Quests", 19 },
                    { "Quest19_1", false, "[Quest Start] First monolith found", "Quest19", 1 },
                    { "Quest19_2", false, "Second monolith found", "Quest19", 2 },
                    { "Quest19_3", false, "Third monolith found", "Quest19", 3 },
                    { "Quest19_4", false, "Fourth monolith found", "Quest19", 4 },
                    { "Quest19_5", false, "Fifth monolith found", "Quest19", 5 },
                    { "Quest19_6", false, "Sixth monolith found", "Quest19", 6 },
                    { "Quest19_7", false, "Seventh monolith found", "Quest19", 7 },
                    { "Quest19_8", false, "[Quest Complete] Mission completed", "Quest19", 8 },
                { "Quest20", false, "The Torment of the Kings", "Quests", 20 },
                    { "Quest20_1", false, "[Quest Start] First monolith found", "Quest20", 1 },
                    { "Quest20_2", false, "Second monolith found", "Quest20", 2 },
                    { "Quest20_3", false, "Third monolith found", "Quest20", 3 },
                    { "Quest20_4", false, "Fourth monolith found", "Quest20", 4 },
                    { "Quest20_5", false, "Fifth monolith found", "Quest20", 5 },
                    { "Quest20_6", false, "Sixth monolith found", "Quest20", 6 },
                    { "Quest20_7", false, "Seventh monolith found", "Quest20", 7 },
                    { "Quest20_8", false, "Eighth monolith found", "Quest20", 8 },
                    { "Quest20_9", false, "Ninth monolith found", "Quest20", 9 },
                    { "Quest20_10", false, "Tenth monolith found", "Quest20", 10 },
                    { "Quest20_11", false, "Eleventh monolith found", "Quest20", 11 },
                    { "Quest20_12", false, "[Quest Complete] Mission completed", "Quest20", 12 },
                { "Quest21", false, "The Origin of Machines", "Quests", 21 },
                    { "Quest21_1", false, "[Quest Start] First computer found", "Quest21", 1 },
                    { "Quest21_2", false, "Second computer found", "Quest21", 2 },
                    { "Quest21_3", false, "Third computer found", "Quest21", 3 },
                    { "Quest21_4", false, "Fourth computer found", "Quest21", 4 },
                    { "Quest21_5", false, "Fifth computer found", "Quest21", 5 },
                    { "Quest21_6", false, "Sixth computer found", "Quest21", 6 },
                    { "Quest21_7", false, "Seventh computer found", "Quest21", 7 },
                    { "Quest21_8", false, "Eighth computer found", "Quest21", 8 },
                    { "Quest21_9", false, "Ninth computer found", "Quest21", 9 },
                    { "Quest21_10", false, "Tenth computer found", "Quest21", 10 },
                    { "Quest21_11", false, "Eleventh computer found", "Quest21", 11 },
                    { "Quest21_12", false, "Twelth computer found", "Quest21", 12 },
                    { "Quest21_13", false, "Thirteenth computer found", "Quest21", 13 },
                    { "Quest21_14", false, "Fourteenth computer found", "Quest21", 14 },
                    { "Quest21_15", false, "Fifteenth computer found", "Quest21", 15 },
                    { "Quest21_16", false, "Sixteenth computer found", "Quest21", 16 },
                    { "Quest21_17", false, "Seventeenth computer found", "Quest21", 17 },
                    { "Quest21_18", false, "[Quest Complete] Mission completed", "Quest21", 18 },
                { "Quest22", false, "Assault on the Core", "Quests", 22 },
                    { "Quest22_1", false, "[Quest Start] Access card to deck C acquired", "Quest22", 1 },
                    { "Quest22_2", false, "Access card to deck B acquired", "Quest22", 2 },
                    { "Quest22_3", false, "Access card to deck A acquired", "Quest22", 3 },
                    { "Quest22_4", false, "Access card to core acquired", "Quest22", 4 },
                    { "Quest22_5", false, "[Quest Complete] Mission completed", "Quest22", 5 },
                { "Quest23", false, "The Temple of Truth", "Quests", 23 },
                    { "Quest23_1", false, "[Quest Start] Get to the Oracle", "Quest23", 1 },
                    { "Quest23_2", false, "First seal found", "Quest23", 2 },
                    { "Quest23_3", false, "Second seal found", "Quest23", 3 },
                    { "Quest23_4", false, "Third seal found", "Quest23", 4 },
                    { "Quest23_5", false, "[Quest Complete] Mission completed", "Quest23", 5 },
                { "Quest24", false, "The Power of Chaos", "Quests", 24 },
                    { "Quest24_1", false, "[Quest Start] Awaken the power of Chaos", "Quest24", 1 },
                    { "Quest24_2", false, "First universal element awakened", "Quest24", 2 },
                    { "Quest24_3", false, "Second universal element awakened", "Quest24", 3 },
                    { "Quest24_4", false, "Third universal element awakened", "Quest24", 4 },
                    { "Quest24_5", false, "All universal elements awakened", "Quest24", 5 },
                    { "Quest24_6", false, "[Quest Complete] Mission completed", "Quest24", 6 },
                { "Quest25", false, "The Enigma of the Oracle", "Quests", 25 },
                    { "Quest25_1", false, "[Quest Start] I must solve the enigma", "Quest25", 1 },
                    { "Quest25_2", false, "First clue found", "Quest25", 2 },
                    { "Quest25_3", false, "Second clue found", "Quest25", 3 },
                    { "Quest25_4", false, "Third clue found", "Quest25", 4 },
                    { "Quest25_5", false, "Fourth clue found", "Quest25", 5 },
                    { "Quest25_6", false, "Fifth clue found", "Quest25", 6 },
                    { "Quest25_7", false, "All clues found.  Find out the word.", "Quest25", 7 },
                    { "Quest25_8", false, "[Quest Complete] Mission completed", "Quest25", 8 },
                { "Quest26", false, "Tribute to the Fallen God", "Quests", 26 },
                    { "Quest26_1", false, "[Quest Start] Seek and destroy all energy sources", "Quest26", 1 },
                    { "Quest26_2", false, "First spear found", "Quest26", 2 },
                    { "Quest26_3", false, "Second spear found", "Quest26", 3 },
                    { "Quest26_4", false, "Third spear found", "Quest26", 4 },
                    { "Quest26_5", false, "Fourth spear found", "Quest26", 5 },
                    { "Quest26_6", false, "All spears found", "Quest26", 6 },
                    { "Quest26_7", false, "[Quest Complete] Mission completed", "Quest26", 7 },
                { "Quest27", false, "The Fall of Light", "Quests", 27 },
                    { "Quest27_1", false, "[Quest Start] Corrupt the palace", "Quest27", 1 },
                    { "Quest27_2", false, "First tower corrupted", "Quest27", 2 },
                    { "Quest27_3", false, "[Quest Complete] Mission completed", "Quest27", 3 },
                { "Quest28", false, "The Edge of the Master", "Quests", 28 },
                    { "Quest28_1", false, "[Quest Start] Find a hilt and defeat the butcher", "Quest28", 1 },
                    { "Quest28_2", false, "Hilt acquired and butcher defeated", "Quest28", 2 },
                    { "Quest28_3", false, "[Quest Complete] Mission completed", "Quest28", 3 },
                { "Quest29", false, "Blood Shuriken", "Quests", 29 },
                    { "Quest29_1", false, "[Quest Start] I must bring a hidden bell from the temple", "Quest29", 1 },
                    { "Quest29_2", false, "Bell acquired", "Quest29", 2 },
                    { "Quest29_3", false, "[Quest Complete] Mission completed", "Quest29", 3 },
                { "Quest30", false, "The Secret of a Noble Weapon", "Quests", 30 },
                    { "Quest30_1", false, "[Quest Start] Defeat 43 enemies using the edge of the master", "Quest30", 1 },
                    { "Quest30_2", false, "Inform the old man", "Quest30", 2 },
                    { "Quest30_3", false, "[Quest Complete] Mission completed", "Quest30", 3 },
                { "Quest31", false, "This Arrow Bears my Name", "Quests", 31 },
                    { "Quest31_1", false, "[Quest Start] Find a place to spoil the companion and get arrows of darkness", "Quest31", 1 },
                    { "Quest31_2", false, "[Quest Complete] Mission completed", "Quest31", 2 },
                { "Quest32", false, "A Rain of Blood", "Quests", 32 },
                    { "Quest32_1", false, "[Quest Start] Find a place to spoil the companion and be able to inject blood", "Quest32", 1 },
                    { "Quest32_2", false, "[Quest Complete] Mission completed", "Quest32", 2 },
                { "Quest33", false, "The Color Purple", "Quests", 33 },
                    { "Quest33_1", false, "[Quest Start] Find a craftsman who can rekindle gems", "Quest33", 1 },
                    { "Quest33_2", false, "[Quest Complete] Mission completed", "Quest33", 2 },
                { "Quest34", false, "Space Odyssey", "Quests", 34 },
                    { "Quest34_1", false, "[Quest Start] Artifact aqcuired, find a translator", "Quest34", 1 },
                    { "Quest34_2", false, "Translator found, get coordinates", "Quest34", 2 },
                    { "Quest34_3", false, "Enter artifact with coordinates into a stargate", "Quest34", 3 },
                    { "Quest34_4", false, "[Quest Complete] Mission completed", "Quest34", 4 },
                { "Quest35", false, "One Last Setback", "Quests", 35 },
                    { "Quest35_1", false, "[Quest Start] Abilities weakened, find a throne", "Quest35", 1 },
                    { "Quest35_2", false, "[Quest Complete] Mission completed", "Quest35", 2 }
    };

    vars.settingsArray = settingsArray;
    vars.quests = new List<string>();

    for (int i = 0; i < vars.settingsArray.GetLength(0); i++)
    {
        var name = vars.settingsArray[i, 0];
        var defaultSetting = vars.settingsArray[i, 1];
        var description = vars.settingsArray[i, 2];
        var parent = vars.settingsArray[i, 3];

        settings.Add(name, defaultSetting, description, parent);
        if (parent == "Quests") vars.quests.Add(name);
    }

    vars.Cutscenes = new List<string>
    {
        "LoadingScreenTutorial",
        "StoryAnimations01",
        "StoryAnimations02",
        "StoryAnimations03",
        "StoryAnimations04",
        "LastFragmentAnimation",
        "StoryAnime1ShortVersion",
        "StoryAnime2",
        "StoryAnime3",
        "StoryAnimePreQueenBattle",
        "StoryAnimePostCredits"
    };

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var messageBox = MessageBox.Show(
            "The game is run in IGT (Time without Loads - Game Time).\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Aeterna Noctis",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question);
        if (messageBox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
    current.progress = 0;
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        var persistentSingleton = helper.GetClass("Assembly-CSharp", "MoreMountains.Tools.PersistentSingleton`1");
        var singleton = helper.GetClass("Assembly-CSharp", "MoreMountains.Tools.Singleton`1");

        var gameManager = helper.GetClass("Assembly-CSharp", "MoreMountains.CorgiEngine.GameManager", 1);
        var levelManager = helper.GetClass("Assembly-CSharp", "MoreMountains.CorgiEngine.LevelManager", 1);
        var progressController = helper.GetClass("Assembly-CSharp", "ProgressController");
        var kingVariables = helper.GetClass("Assembly-CSharp", "KingVariables");
        var progressHUD = helper.GetClass("Assembly-CSharp", "ProgressHUD");

        var questManager = helper.GetClass("Assembly-CSharp", "QuestManager", 1);
        var list = helper.GetClass("mscorlib", "List`1");
        var quest = helper.GetClass("Assembly-CSharp", "Quest");

        vars.Unity.Make<int>(progressController.Static, progressController["Progress"], progressController["bossesDefeated"]).Name = "bossWatcher";
        vars.Unity.Make<int>(progressController.Static, progressController["Progress"], progressController["kingAbilities"]).Name = "abilitiesWatcher";
        vars.Unity.Make<int>(progressController.Static, progressController["Progress"], progressController["kingWeapons"]).Name = "weaponsWatcher";
        vars.Unity.Make<int>(kingVariables.Static, kingVariables["_progressHUD"], progressHUD["_currentProgress"]).Name = "currentProgressWatcher";
        vars.Unity.Make<int>(levelManager.Static, singleton["_instance"], levelManager["playedTime"]).Name = "playedTimeWatcher";
        vars.Unity.Make<bool>(gameManager.Static, persistentSingleton["_instance"], gameManager["_pauseMenuOpen"]).Name = "pausedWatcher";

        for (int i = 0; i < vars.settingsArray.GetLength(0); i++)
        {
            var name = vars.settingsArray[i, 0];
            var parent = vars.settingsArray[i, 3];
            var value = vars.settingsArray[i, 4];

            if (parent == "Quests")
            {
                vars.Unity.Make<int>(questManager.Static, persistentSingleton["_instance"], questManager["QuestList"], list["_items"], 0x20 + (0x8 * value), quest["_currentStageIndex"]).Name = name;
            }
        }

        return true;
    });

    vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;
    vars.Unity.Update();

    if (vars.Unity.Scenes.Active.Name != String.Empty) current.Scene = vars.Unity.Scenes.Active.Name;
    if (old.Scene != current.Scene) vars.Log("Scene Change: " + vars.Unity.Scenes.Active.Index.ToString() + ": " + current.Scene);

    if (vars.Unity["currentProgressWatcher"].Current > current.progress && vars.Unity["currentProgressWatcher"].Current < current.progress + 10) 
        current.progress = vars.Unity["currentProgressWatcher"].Current;
}

isLoading
{
    if (settings["UseDevTime"]) return true;

    return ((settings["PauseStop"] && vars.Unity["pausedWatcher"].Current)
            || (settings["CutSceneStop"] && vars.Cutscenes.Contains(current.Scene))
            || vars.Unity.Scenes.Active.Name == String.Empty || current.Scene == "LoadingScene" || vars.Unity.Scenes.Count > 1);
}

gameTime
{
    if (settings["UseDevTime"] && vars.Unity["playedTimeWatcher"].Changed) return TimeSpan.FromSeconds(vars.Unity["playedTimeWatcher"].Current);
    if (settings["CutSceneStop"] && current.Scene == "LoadingScreenTutorial") return TimeSpan.Zero;
}

start
{
    current.progress = 0;
    vars.queuedSplits = 0;
    return (current.Scene == "LoadingScreenTutorial");
}

reset
{
    return (current.Scene == "MainMenuV2");
}

split
{
    for (int i = 0; i < vars.settingsArray.GetLength(0); i++)
    {
        var name = vars.settingsArray[i, 0];
        var description = vars.settingsArray[i, 2];
        var parent = vars.settingsArray[i, 3];
        var value = vars.settingsArray[i, 4];

        if  (vars.Unity["bossWatcher"].Changed && parent == "Bosses" &&
            vars.Unity["bossWatcher"].Current == vars.Unity["bossWatcher"].Old + value)
        {
            vars.Log("Boss: " +  description + " defeated!");
            if (settings[name]) vars.queuedSplits++;
        }

        if (parent == "Scenes" && old.Scene != name && current.Scene == name)
        {
            vars.Log("Scene: " + description + " reached!");
            if (settings[name]) vars.queuedSplits++;
        }

        if  (vars.Unity["abilitiesWatcher"].Changed && parent == "Abilities" &&
            vars.Unity["abilitiesWatcher"].Current == vars.Unity["abilitiesWatcher"].Old + value)
        {
            vars.Log("Ability: " + description + " acquired!");
            if (settings[name]) vars.queuedSplits++;
        }

        if  (vars.Unity["weaponsWatcher"].Changed && parent == "Weapons" &&
            vars.Unity["weaponsWatcher"].Current == vars.Unity["weaponsWatcher"].Old + value)
        {
            vars.Log("Weapon: " + description +  " acquired!");
            if (settings[name]) vars.queuedSplits++;
        }

        if  (parent == "Completion" && current.progress <= vars.maxProgress && old.progress < value && current.progress >= value)
        {
            vars.Log("Completion: " + description +  " completion reached!");
            if (settings[name]) vars.queuedSplits++;
        }

        if (vars.quests.Contains(parent) &&
            vars.Unity[parent].Old < value && vars.Unity[parent].Current >= value)
        {
            vars.Log("Quest stage: (" +  name + ") " + description + " reached!");
            if (settings[name]) vars.queuedSplits++;
        }
    }

    if (vars.queuedSplits > 0)
    {
        vars.Log("Splitting");
        vars.queuedSplits--;
        return true;
    }
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}