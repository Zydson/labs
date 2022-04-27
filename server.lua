ESX = nil
TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)
luski = {}
AddEventHandler("weaponDamageEvent", function(sender, data)
	math.randomseed(os.time())
	if math.random(1,2) == 1 then
		local xPlayer = ESX.GetPlayerFromId(sender)
		local job = xPlayer.job.name
		if job == "sheriff" then
			police = true
		else
			police = false
		end
		local hashbroni = data.weaponType
		if Config.Weapons[hashbroni] then
			local informacje = {
				coords = GetEntityCoords(GetPlayerPed(sender)),
				stime = os.date("%H")..":"..os.date("%M"),
				ispolice = police,
				weapon = Config.Weapons[hashbroni],
			}
			table.insert(luski,informacje)
			changed = true
		else
			return
		end
	else
		return
	end
end)

RegisterNetEvent('luskawez')
AddEventHandler('luskawez', function(id)
	table.remove(luski,id)
	TriggerClientEvent("luskiget",-1,luski)
end)


--[[ NEED TO REWORK ]]--
CreateThread(function()
while true do
Wait(30000)
if changed then
	changed = false
	for i=1, GetNumPlayerIndices() do 
		local id = GetPlayerFromIndex(i)
		if GetPlayerName(id) ~= nil then
			local xPlayer = ESX.GetPlayerFromId(id)
			if xPlayer.job.name == "sheriff" then
				TriggerClientEvent("luskiget",id,luski)
			end
		end
	end
end
end
end)