state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
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

    vars.CutsceneIndex = -1;
    current.Cutscene = "";
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    current.Cutscene = "";
    int widgetCount = vars.Helper.Read<int>(vars.GEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0xB8);
    bool foundCutscene = false;

    for (int i = 0; i < widgetCount && !foundCutscene; i++)
    {
        IntPtr widget = vars.Helper.Deref(vars.GEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0xB0, 0x30 * i + 0x20);
        
        if (widget != IntPtr.Zero)
        {
            string widgetName = vars.FNameToString(vars.Helper.Read<ulong>(widget, 0x18));

            if (widgetName.StartsWith("WBP_Cutscene_C"))
            {
                if (vars.CutsceneIndex != i)
                {
                    vars.CutsceneIndex = i;
                    // vars.Log("Cutscene widget at index " + i);
                }
                
                ulong cutsceneName = vars.Helper.Read<ulong>(widget, 0x460);
                if (cutsceneName != 0)
                {
                    string cutscene = vars.FNameToString(cutsceneName);
                    if (!string.IsNullOrEmpty(cutscene) && cutscene != "None")
                    {
                        current.Cutscene = cutscene;
                    }
                }
                
                foundCutscene = true;
            }
        }
    }

    // No cutscene widget found
    if (!foundCutscene && vars.CutsceneIndex >= 0)
    {
        vars.CutsceneIndex = -1;
    }

    if (old.Cutscene != current.Cutscene) vars.Log("Cutscene: " + current.Cutscene);
}