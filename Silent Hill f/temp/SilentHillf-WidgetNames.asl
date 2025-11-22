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
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    vars.GEngine = gEngine;

    if (gEngine == IntPtr.Zero)
        throw new Exception("GEngine address could not be found.");

    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        var fNameIdx = fName & 0x000000000000FFFF;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 16;
        var number = (fName & 0xFFFFFFFF00000000) >> 32;

        IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");
        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)fNameIdx * sizeof(short);

        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    // Tracks previous widget names to detect updates
    vars.WidgetNames = new Dictionary<int, string>();
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    int widgetCount = vars.Helper.Read<int>(vars.GEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0xB8);

    for (int i = 0; i < widgetCount; i++)
    {
        IntPtr widget = vars.Helper.Deref(vars.GEngine, 0x10A8, 0x38, 0x0, 0x30, 0x338, 0x9E8, 0xB0, 0x30 * i + 0x20);
        if (widget == IntPtr.Zero) continue;

        ulong fNameVal = vars.Helper.Read<ulong>(widget, 0x18);
        string widgetName = vars.FNameToString(fNameVal);

        string prevName = null;
        vars.WidgetNames.TryGetValue(i, out prevName);

        if (prevName != widgetName)
        {
            vars.WidgetNames[i] = widgetName;
            vars.Log("Widget[" + i + "] Name: " + widgetName);
        }
    }

    // Remove any stale widget indices
    var toRemove = new List<int>();
    foreach (var kvp in vars.WidgetNames)
    {
        if (kvp.Key >= widgetCount)
            toRemove.Add(kvp.Key);
    }
    foreach (var idx in toRemove)
        vars.WidgetNames.Remove(idx);
}
