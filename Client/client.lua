-- FRAMEWORK CHECK
if Config.FrameWork.ESX then
	ESX = nil
	TriggerEvent(Config.ESXSharedEvent, function(obj) ESX = obj end)
elseif Config.FrameWork.QBcore then
	QBCore = exports['qb-core']:GetCoreObject()
end

-- LANGUAGE CHECK
if string.find(Config.Translation,"PL") or string.find(Config.Translation,"EN") then
else
	Config.Translation = "EN" -- SET DEFAULT LANGUAGE IF THERE IS CONFIG ERROR
end

--[[
	FUNCTIONS
--]]

function Notification(txt)
	if Config.FrameWork.ESX then
		ESX.ShowNotification(txt)
	elseif Config.FrameWork.QBcore then
		TriggerEvent('QBCore:Notify', tostring(txt), 'success')
	else
		SetNotificationTextEntry('STRING')
		AddTextComponentSubstringPlayerName(txt)
		DrawNotification(false, true)
	end
end

function last()
    local camCoords = GetPedBoneCoords(pid, 37193, 0.0, 0.0, 0.0)
    local farCoords = GetCoordsFromCam()
    local RayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords, farCoords, -1, pid, 4)
    local _, hit, endcoords = GetShapeTestResult(RayHandle)
    if endcoords[1] == 0.0 then return end
    return endcoords
end
function GetCoordsFromCam()
    local rot = GetGameplayCamRot(2)
    local coord = GetGameplayCamCoord()
    local tZ = rot.z * 0.0174532924
    local tX = rot.x * 0.0174532924
    local num = math.abs(math.cos(tX))
    a = coord.x + (-math.sin(tZ)) * (num + 4.0)
    b = coord.y + (math.cos(tZ)) * (num + 4.0)
    c = coord.z + (math.sin(tX) * 8.0)
    return vector3(a, b, c)
end

function PickUpShell(id)
	table.insert(pickedup,shell[id])
	TriggerServerEvent("shell:take",id)
	Notification(Translation[Config.Translation].takeshell)
	Wait(1500)
	picked = false
end

function LowestValue(t)
  local k
  for i, v in pairs(t) do
    k = k or i
    if v < t[k] then k = i end
  end
  return k
end

--[[
	THREADS
--]]

shell = {}
shell_onscreen = {}
pickedup = {}
picked = false
CreateThread(function()
while true do
ped = GetPlayerPed(-1)
pid = PlayerPedId()
id = PlayerId()
selectedweapon = GetSelectedPedWeapon(ped)
Wait(5000)
end
end)

CreateThread(function()
  while true do
	if tonumber(selectedweapon) == -1951375401 then
		if IsPlayerFreeAiming(id) then
			if #shell ~= 0 then
			Wait(4)
			shell_onscreen = {}
			for i=1, #shell do
				local objectcoords = shell[i].coords
				local playercoords = GetEntityCoords(pid)
				if #(playercoords-objectcoords) < 3.5 then
					local grounded,zcord = GetGroundZFor_3dCoord(objectcoords.x,objectcoords.y,objectcoords.z,1)
					local camcord = last()
					if camcord ~= nil then
						local coordszcord = vector3(objectcoords.x,objectcoords.y,zcord+0.2)
						local camdist = #(camcord-coordszcord)
						if camdist < 1.0 then
							table.insert(shell_onscreen,camdist)
							if camdist == LowestValue(shell_onscreen) then
								triggered = i
								DrawMarker(28, coordszcord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.02, 0.02, 189, 14, 4, 140, false, true, 2, nil, nil, false)
							else
								DrawMarker(28, coordszcord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.02, 0.02, 237, 255, 14, 140, false, true, 2, nil, nil, false)
							end
							if IsControlJustReleased(0, 38) then
								if not picked then
									picked = true
									PickUpShell(triggered)
								end
							end
						end
					end
				end
			end
			else
			Wait(10000)
			end
		else
			Wait(1500)
		end
	else
		Wait(4000)
	end
  end
end)

-- TEMPORAILY HERE --
RegisterCommand("latarka", function()
	SetCurrentPedWeapon(ped,-1951375401,true)
	GiveWeaponToPed(ped,-1951375401,1,false,true)
end, false)

--[[
	EVENTS
--]]

RegisterNetEvent("shell:get", function(l)
	shell = l
end)
