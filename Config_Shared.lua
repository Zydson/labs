Config = {}
Translation = {}
-- [AVAILABLE LANGUAGES] --
-- PL, EN
Config.Translation = "PL"

-- [FRAMEWORK] --
Config.FrameWork = {
	ESX = true,
	QBcore = false
}

-- [JOB NAMES WITH ACCESS] --
Config.JobName = {
	["sheriff"] = true,
	["ambulance"] = true
}

-- [LAB COORDS] --
Config.LabCoordsGive = vector3(482.513, -988.598, 29.68)
Config.LabCoordsCloset = vector3(482.7572, -992.8956, 29.68)

-- ESX GetSharedObject event if needed -- TODO: automaticate this
Config.ESXSharedEvent = "esx:getShtestaredObjtestect"

Translation["PL"] = {
	takeshell = "Zapakowałeś łuskę do woreczka, zanieś go do labolatorium",
	description = "Opis [5-30 znaków]",
	descriptionerror = "Błąd w opisie",
	giveshell = "Oddałeś łuskę, dokumenty trafią do szafy po jej zbadaniu",
	noshells = "Nie posiadasz przy sobie żadnych łusek",
	pressgive = "Naciśnij ~INPUT_CONTEXT~, aby oddać łuskę do labolatorium",
	pressopen = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć szafę",
	binddesc = "Otwieranie menu w labach",
	shell = "Łuska",
	police = "Policyjne",
	civil = "Cywilne",
	docs = "Dokumenty",
	lab = "Labolatorium",
	delete = "[Usuń]",
	pistol = "Pistolet",
	combat = "Pistolet Bojowy",
	snsmk = "Pukawka Mk2",
	sns = "Pukawka",
	mk = "Pistolet Mk2",
	vintage = "Pistolet Vintage",
	heavy = "Ciezki Pistolet"
}

Translation["EN"] = {
	takeshell = "You packed the shell into a bag, take it to the lab",
	description = "Description [5-30 chars]",
	descriptionerror = "Error in the description",
	giveshell = "You gave the bag, the documents will go to the closet after examining it",
	noshells = "You don't have any shells in your pocket",
	pressgive = "Press ~INPUT_CONTEXT~ to return the shell to the laboratory",
	pressopen = "Press ~INPUT_CONTEXT~ to open the closet",
	binddesc = "Open lab menu",
	shell = "Shell",
	police = "Police",
	civil = "Civil",
	docs = "Documents",
	lab = "Lab",
	delete = "[Delete]",
	pistol = "Pistol",
	combat = "Combat Pistol",
	snsmk = "SNS Pistol Mk2",
	sns = "SNS Pistol",
	mk = "Pistol Mk2",
	vintage = "Vintage Pistol",
	heavy = "Heavy Pistol"
}

Config.Weapons = {
	[453432689] = Translation[Config.Translation].pistol,
	[1593441988] = Translation[Config.Translation].combat,
	[2285322324] = Translation[Config.Translation].snsmk,
	[3218215474] = Translation[Config.Translation].sns,
	[3219281620] = Translation[Config.Translation].mk,
	[137902532] = Translation[Config.Translation].vintage,
	[3523564046] = Translation[Config.Translation].heavy
}
