if Config.FrameWork.ESX then
	ESX = nil
	TriggerEvent(Config.ESXSharedEvent, function(obj) ESX = obj end)
elseif Config.FrameWork.QBcore then
	-- TODO: QBcore implementation
end
shell = {}
AddEventHandler("weaponDamageEvent", function(sender, data)
	math.randomseed(os.time())
	if math.random(1,2) == 1 then
		local src = sender
		if not Config.FrameWork.StandAlone then
			if Config.FrameWork.ESX then
				local xPlayer = ESX.GetPlayerFromId(src)
				local job = xPlayer.job.name
			elseif
				-- TODO: QBcore implementation
			end
			if job == "sheriff" then
				police = true
			else
				police = false
			end
		else
			police = "none"
		end
		local weapon_hash = data.weaponType
		if Config.Weapons[weapon_hash] then
			local info = {
				coords = GetEntityCoords(GetPlayerPed(src)),
				stime = os.date("%H")..":"..os.date("%M"),
				ispolice = police,
				weapon = Config.Weapons[weapon_hash],
			}
			table.insert(shell,info)
			changed = true
		else
			return
		end
	else
		return
	end
end)

RegisterNetEvent('shell:take')
AddEventHandler('shell:take', function(id)
	table.remove(shell,id)
	updatePlayers()
end)

--[[ NEED TO REWORK ]]--
CreateThread(function()
while true do
Wait(30000)
if changed then
	changed = false
	updatePlayers()
end
end
end)

function updatePlayers()
	for i=1, GetNumPlayerIndices() do 
		local id = GetPlayerFromIndex(i)
		if GetPlayerName(id) ~= nil then
			if Config.FrameWork.ESX then
				local xPlayer = ESX.GetPlayerFromId(id)
				if xPlayer.job.name == "sheriff" then
					TriggerClientEvent("shell:get",id,shell)
				end
			elseif Config.FrameWork.QBcore then
				-- TODO: QBcore implementation
			else
				TriggerClientEvent("shell:get",id,shell)
			end
		end
	end
end
