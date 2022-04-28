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
	print(id)
	TriggerServerEvent("shell:take",id)
	Notification(Translation[Config.Translation].takeshell)
end

function LowestValue(t)
  local k
  for i, v in pairs(t) do
    k = k or i
    if v < t[k] then k = i end
  end
  return k
end

function LabMenu()
	if #pickedup ~= 0 then
		local elements = {}
		for i=1,#pickedup do
			table.insert(elements, {label = 'Luska ['..tostring(pickedup[i].id)..']', value = pickedup[i].id})
		end
		ESX.UI.Menu.CloseAll()
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'luski', 
		{
			title    = ('Laboratorium'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
		for i=1,#pickedup do
			if tostring(pickedup[i].id) == tostring(data.current.value) then
				TriggerServerEvent("shell:give",
					pickedup[i].weapon,
					pickedup[i].hour,
					pickedup[i].minute,
					pickedup[i].ispolice,
					pickedup[i].id
				)
				Notification("Oddałeś łuskę, wkrótce otrzymasz smsa z informacjami")
				table.remove(pickedup,i)
				menu.close()
			end
		end
		end, function(data, menu)
			menu.close()
		end)
	else
		Notification("Nie posiadasz przy sobie żadnych łusek")
	end
end

--[[
	THREADS
--]]

shell = {}
shell_onscreen = {}
pickedup = {}
counter = 0
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
			counter = 0
			for i=1, #shell do
				if shell[i] ~= nil then
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
								local lowest = shell_onscreen[LowestValue(shell_onscreen)]
								if camdist == lowest then
									if tonumber(counter) == 0 then
										counter = 1
										triggered = i
										DrawMarker(28, coordszcord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.02, 0.02, 189, 14, 4, 140, false, true, 2, nil, nil, false)
									else
										DrawMarker(28, coordszcord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.02, 0.02, 237, 255, 14, 140, false, true, 2, nil, nil, false)
									end
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

CreateThread(function()
while true do
Wait(100)
if picked then
	Wait(1500)
	picked = false
end
end
end)

CreateThread(function()
while true do
Wait(4)
local MarkerDist = #(GetEntityCoords(pid)-Config.LabCoords)
if MarkerDist < 9.0 then
	DrawMarker(1, Config.LabCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.7, 237, 255, 14, 140, false, true, 2, nil, nil, false)
	if MarkerDist < 1.1 then
		ESX.ShowHelpNotification("Naciśnij ~INPUT_CONTEXT~ aby oddać łuske do labolaborium")
	end
else
	Wait(1500)
end
end
end)

RegisterCommand("openlab", function()
	if #(GetEntityCoords(pid)-Config.LabCoords) < 1.1 then
		LabMenu()
	end
end, false)

RegisterKeyMapping("openlab","Otwieranie menu labow","keyboard","E")

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
