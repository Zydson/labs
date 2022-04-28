Config = {}
Translation = {}
-- [AVAILABLE LANGUAGES] --
-- PL, EN
Config.Translation = "PL" 

-- [FRAMEWORK] --
Config.FrameWork = {
    ESX = true,
    QBcore = false,
    StandAlone = false,
}

-- [JOB NAMES WITH ACCESS] --
Config.JobName = {
	["sheriff"] = true,
	["ambulance"] = true,
}

-- [LAB COORDS] --
Config.LabCoords = vector3(482.513,-988.598,29.68)

-- ESX GetSharedObject event if needed -- TODO: automaticate this
Config.ESXSharedEvent = "esx:getShtestaredObjtestect"

Translation["PL"] = {
    takeshell = "Zapakowałeś łuskę do woreczka, zanieś go do laboratorium",
	pistol = "Pistolet",
	combat = "Pistolet Bojowy",
	snsmk = "Pukawka Mk2",
	sns = "Pukawka",
	mk = "Pistolet Mk2",
	vintage = "Pistolet Vintage",
	heavy = "Ciezki Pistolet",
}

Translation["EN"] = {
    takeshell = "U packed shell to bag, take it to labs",
	pistol = "Pistol",
	combat = "Combat Pistol",
	snsmk = "SNS Pistol Mk2",
	sns = "SNS Pistol",
	mk = "Pistol Mk2",
	vintage = "Vintage Pistol",
	heavy = "Heavy Pistol",
}

Config.Weapons = {
[453432689] = Translation[Config.Translation].pistol,
[1593441988] = Translation[Config.Translation].combat,
[2285322324] = Translation[Config.Translation].snsmk,
[3218215474] = Translation[Config.Translation].sns,
[3219281620] = Translation[Config.Translation].mk,
[137902532] = Translation[Config.Translation].vintage,
[3523564046] = Translation[Config.Translation].heavy,
}
