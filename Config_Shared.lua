Config = {}
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

-- ESX GetSharedObject event if needed -- TODO: automaticate this
Config.ESXSharedEvent = "esx:getShtestaredObjtestect"

Config.Weapons = {
[453432689] = Translation[Config.Translation].pistol,
[1593441988] = Translation[Config.Translation].combat,
[2285322324] = Translation[Config.Translation].snsmk,
[3218215474] = Translation[Config.Translation].sns,
[3219281620] = Translation[Config.Translation].mk,
[137902532] = Translation[Config.Translation].vintage,
[3523564046] = Translation[Config.Translation].heavy,
}
