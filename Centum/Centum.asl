state("Centum"){
    // int PersonalityPointsMurderer : "GameAssembly.dll", 0x01E942E8, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x20, 0x18, 0x10, 0x10, 0x20;
    // int PersonalityPointsArtist : "GameAssembly.dll", 0x01E942E8, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x28, 0x18, 0x10, 0x10, 0x20;
    // int PersonalityPointsProphet : "GameAssembly.dll", 0x01E942E8, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x30, 0x18, 0x10, 0x10, 0x20;
    // int PersonalityPointsWarrior : "GameAssembly.dll", 0x01E942E8, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x38, 0x18, 0x10, 0x10, 0x20;
    // string100 technicalName : "GameAssembly.dll", 0x01E942E8, 0xB8, 0x0, 0x30, 0x58;

    int PersonalityPointsMurderer : "GameAssembly.dll", 0x01E91340, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x20, 0x18, 0x10, 0x10, 0x20;
    int PersonalityPointsArtist : "GameAssembly.dll", 0x01E91340, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x28, 0x18, 0x10, 0x10, 0x20;
    int PersonalityPointsProphet : "GameAssembly.dll", 0x01E91340, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x30, 0x18, 0x10, 0x10, 0x20;
    int PersonalityPointsWarrior : "GameAssembly.dll", 0x01E91340, 0xB8, 0x0, 0x30, 0x28, 0x38, 0x10, 0x38, 0x18, 0x10, 0x10, 0x20;
    string100 technicalName : "GameAssembly.dll", 0x01E91340, 0xB8, 0x0, 0x58, 0x14;
}

startup
{
    settings.Add("FFr_7B6C368D", true, "_100.bat - Day 1"); // or FFr_7B6C368D when going into gameplay not text
    settings.Add("FFr_FF8DAE79", true, "_100.bat - Night 1"); 
    settings.Add("Enemy HP", true, "Enemy HP");
}

start
{
    if (old.technicalName != current.technicalName && current.technicalName == "FFr_B11DCB93") return true;
}

update
{
   if (old.PersonalityPointsMurderer != current.PersonalityPointsMurderer) print("Personality Points: Murderer - " + current.PersonalityPointsMurderer.ToString());
   if (old.PersonalityPointsArtist != current.PersonalityPointsArtist) print("Personality Points: Artist - " + current.PersonalityPointsArtist.ToString());
   if (old.PersonalityPointsProphet != current.PersonalityPointsProphet) print("Personality Points: Prophet - " + current.PersonalityPointsProphet.ToString());
   if (old.PersonalityPointsWarrior != current.PersonalityPointsWarrior) print("Personality Points: Warrior - " + current.PersonalityPointsWarrior.ToString());
   if (old.technicalName != current.technicalName) print("technicalName: " + current.technicalName);
}

split
{
    if (old.technicalName != current.technicalName && settings[current.technicalName])
    {
        return true;
    }
}
