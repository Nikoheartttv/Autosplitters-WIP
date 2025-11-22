state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.Settings.CreateFromXml("Components/SilentHillf.Settings.xml");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
    vars.Uhara.EnableDebug();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");


    vars.GEngine = gEngine;

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
        throw new Exception("Not all required addresses could be found by scanning.");

    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);
        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});

    // uhara9
    var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    IntPtr WBP_Cutscene_C = Events.InstancePtr("WBP_Cutscene_C", "");
    vars.Helper["CutsceneName"] = vars.Helper.Make<uint>(WBP_Cutscene_C, 0x460);
    vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
        
    // asl-help
    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    // GWorld -> GameState -> GameProgress -> ExactProgressTag
    vars.Helper["ProgressTag"] = vars.Helper.Make<ulong>(gWorld, 0x160, 0x328, 0x250);
    vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x18);
	vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

    current.World = "";
    current.Progress = "";
    current.Cutscene = "";

    // item tracking maps
    vars.KeyItem = new Dictionary<ulong, int>();
    vars.FNameCache = new Dictionary<ulong, string>();


}

update
{
    // --- Update helper and map pointers ---
    vars.Helper.Update();
    vars.Helper.MapPointers();

    // === World tracking ===
    var world = vars.FNameToString(current.GWorldName);
    if (!string.IsNullOrEmpty(world) && world != "None") current.World = world;
    if (old.World != current.World) 
        vars.Log("World: " + current.World);

    // === Progress tracking ===
    var progress = vars.FNameToString(current.ProgressTag);
    if (!string.IsNullOrEmpty(progress)) current.Progress = progress;
    if (old.Progress != current.Progress && current.World == "NoceWorld") 
        vars.Log("Progress: " + current.Progress);

    // === Cutscene tracking ===
    if (current.CutsceneName != old.CutsceneName)
    {
        if (current.CutsceneName != 0)
        {
            string cutscene = vars.FNameToString(current.CutsceneName);
            current.Cutscene = cutscene ?? "";
        }
        else current.Cutscene = "";
    }

    if (old.Cutscene != current.Cutscene) vars.Log("Cutscene: " + current.Cutscene);

    // === Key Item tracking ===
    if (vars.FNameToShortString2(current.AcknowledgedPawn) == "BP_Pl_Hina_C_")
    {
        for (int i = 0; i < 87; i++)
        {
            ulong item = vars.Helper.Read<ulong>(
                vars.GEngine, 0x10A8, 0x38, 0x0, 0x30,
                0x298, 0x408, 0x350, 0x0 + (i * 0x8)
            );

            int collected = vars.Helper.Read<int>(
                vars.GEngine, 0x10A8, 0x38, 0x0, 0x30,
                0x298, 0x408, 0x330, 0x0 + (i * 0x1)
            );

            int oldcollected = vars.KeyItem.ContainsKey(item) ? vars.KeyItem[item] : -1;
            vars.KeyItem[item] = collected;

            if (collected != oldcollected)
            {
                if (!vars.FNameCache.ContainsKey(item))
                    vars.FNameCache[item] = vars.FNameToString(item);

                string name = vars.FNameCache[item];
                vars.Log("Item: " + name + " | Collected = " + collected);
            }
        }
    }
}

split
{
    // === Key Item Splits ===
    if(vars.FNameToShortString2(current.AcknowledgedPawn) == "BP_Pl_Hina_C_")
    {
        for(int i = 0; i < 87; i++)
        {
            ulong item = vars.Helper.Read<ulong>(
                vars.GEngine, 0x10A8, 0x38, 0x0, 0x30,
                0x298, 0x408, 0x350, 0x0 + (i * 0x8)
            );

            int collected = vars.Helper.Read<int>(
                vars.GEngine, 0x10A8, 0x38, 0x0, 0x30,
                0x298, 0x408, 0x330, 0x0 + (i * 0x1)
            );

            int oldcollected = vars.KeyItem.ContainsKey(item) ? vars.KeyItem[item] : -1;
            vars.KeyItem[item] = collected;

            if(collected == 1 && oldcollected == 0)
            {
                if(!vars.FNameCache.ContainsKey(item))
                    vars.FNameCache[item] = vars.FNameToString(item);

                string setting = vars.FNameCache[item] + "_1";

                if(!string.IsNullOrEmpty(setting) && settings.ContainsKey(setting) && settings[setting] && !vars.CompletedSplits.Contains(setting))
                {
                    vars.CompletedSplits.Add(setting);
                    vars.Log("Split Complete: " + setting);
                    return true;
                }
            }
        }
    }

    // === Cutscene Splits ===
    if(!string.IsNullOrEmpty(current.Cutscene) && old.Cutscene != current.Cutscene)
    {
        string cutsceneSetting = current.Cutscene;

        if(settings.ContainsKey(cutsceneSetting) && settings[cutsceneSetting] && !vars.CompletedSplits.Contains(cutsceneSetting))
        {
            vars.CompletedSplits.Add(cutsceneSetting);
            vars.Log("Split Complete: " + cutsceneSetting);
            return true;
        }
    }

    // === Progress / Chapter Splits ===
    if(!string.IsNullOrEmpty(current.Progress) && old.Progress != current.Progress && current.World == "NoceWorld")
    {
        string progressSetting = current.Progress;

        if(settings.ContainsKey(progressSetting) && settings[progressSetting] && !vars.CompletedSplits.Contains(progressSetting))
        {
            vars.CompletedSplits.Add(progressSetting);
            vars.Log("Split Complete: " + progressSetting);
            return true;
        }
    }

    // === General XML-defined Splits ===
    foreach(var kvp in settings)
    {
        string id = kvp.Key;
        bool enabled = kvp.Value;

        if(enabled && !vars.CompletedSplits.Contains(id))
        {
            vars.CompletedSplits.Add(id);
            vars.Log("Split triggered: " + id);
            return true;
        }
    }
}

