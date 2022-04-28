if Config.FrameWork.ESX then
	ESX = nil
	TriggerEvent(Config.ESXSharedEvent, function(obj) ESX = obj end)
elseif Config.FrameWork.QBcore then
	QBCore = exports['qb-core']:GetCoreObject()
end

shell = {}

AddEventHandler("weaponDamageEvent", function(sender, data)
	if data.weaponDamage ~= 500 then -- KOLBA
		math.randomseed(os.time())
		--if math.random(1,2) == 1 then
			local src = sender
			if not Config.FrameWork.StandAlone then
				if Config.FrameWork.ESX then
					local xPlayer = ESX.GetPlayerFromId(src)
					job = xPlayer.job.name
				elseif Config.FrameWork.QBcore then
					local xPlayer = QBCore.Functions.GetPlayer(src)
					job = xPlayer.PlayerData.job.name
				end
				if Config.JobName[job] then
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
					hour = os.date("%H"),
					minute = os.date("%M"),
					ispolice = police,
					weapon = Config.Weapons[weapon_hash],
					id = math.random(10000,1000000),
				}
				table.insert(shell,info)
				changed = true
			else
				return
			end
		--else
		--	return
		--end
	else
		return
	end
end)

RegisterNetEvent('shell:give')
AddEventHandler('shell:give', function(weapon,hour,minute,ispolice,id)
	local time = tostring(GetFarTime(hour,minute))
end)

RegisterNetEvent('shell:take')
AddEventHandler('shell:take', function(id)
	table.remove(shell,id)
	updatePlayers()
end)

--[[ NEED TO REWORK ]]--
CreateThread(function()
while true do
Wait(5000)
if changed then
	changed = false
	updatePlayers()
end
end
end)

function updatePlayers()
	for i=0, GetNumPlayerIndices() do 
		local id = GetPlayerFromIndex(i)
		if id ~= nil and id ~= 0 then
			if GetPlayerName(id) ~= nil then
				if Config.FrameWork.ESX then
					local xPlayer = ESX.GetPlayerFromId(id)
					if xPlayer ~= nil then
						if Config.JobName[xPlayer.job.name] then
							TriggerClientEvent("shell:get",id,shell)
						end
					end
				elseif Config.FrameWork.QBcore then
					local xPlayer = QBCore.Functions.GetPlayer(src)
					if xPlayer ~= nil then
						if Config.JobName[xPlayer.PlayerData.job.name] then
							TriggerClientEvent("shell:get",id,shell)
						end
					end
				else
					TriggerClientEvent("shell:get",id,shell)
				end
			end
		end
	end
end

function GetFarTime(h,min)
math.randomseed(os.time())
local whenrand = math.random(15,30)
local cgodzina = h
local cminuta = min + whenrand
if cminuta > 59 then
	cminuta = cminuta - 60
	cgodzina = cgodzina + 1
end
if string.len(cminuta) == 1 then
	cminuta = tostring("0"..cminuta)
end
local poprzetworzeniu = tostring(cgodzina..":"..cminuta)
local whenrand = math.random(10,20)
local cgodzina = h
local cminuta = min - whenrand
if cminuta < 1 then
	cminuta = cminuta + 60
	cgodzina = cgodzina - 1
end
if string.len(cminuta) == 1 then
	cminuta = tostring("0"..cminuta)
end
local poprzetworzeniudwa = tostring(cgodzina..":"..cminuta)
local koncowa = tostring(poprzetworzeniudwa.." - "..poprzetworzeniu)
return koncowa
end
