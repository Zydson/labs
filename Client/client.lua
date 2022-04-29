-- FRAMEWORK CHECK
if Config.FrameWork.ESX then
	ESX = nil

	TriggerEvent(
		Config.ESXSharedEvent,
		function(obj)
			ESX = obj
		end
	)
elseif Config.FrameWork.QBcore then
	QBCore = exports["qb-core"]:GetCoreObject()
end

-- LANUGAGE CHECK
if Config.Translation ~= "PL" and Config.Translation ~= "EN" then
	Config.Translation = "EN" -- SET DEFAULT LANGUAGE IF THERE IS CONFIG ERROR
end

--[[
	VARIABLES
--]]
local PED, PID, ID, SELECTED_WEAPON
local SHELL = {}
local SHELLS_ON_SCREEN = {}
local PICKED_UP = {}
local COUNTER = 0
local PICKED = false

CreateThread(
	function()
		while true do
			PED = GetPlayerPed(-1)
			PID = PlayerPedId()
			ID = PlayerId()
			SELECTED_WEAPON = GetSelectedPedWeapon(PED)

			Wait(5000)
		end
	end
)

--[[
	FUNCTIONS
--]]
local function notify(txt)
	if Config.FrameWork.ESX then
		ESX.ShowNotification(txt)
	elseif Config.FrameWork.QBcore then
		TriggerEvent("QBCore:Notify", tostring(txt), "success")
	end
end

local function getCoordsFromCam()
	local a, b, c
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

local function getCamCoords()
	local camCoords = GetPedBoneCoords(PID, 37193, 0.0, 0.0, 0.0)
	local farCoords = getCoordsFromCam()
	local RayHandle =
		StartExpensiveSynchronousShapeTestLosProbe(camCoords, farCoords, -1, PID, 4)
	local _, _, endcoords = GetShapeTestResult(RayHandle)

	if endcoords[1] == 0.0 then
		return
	end

	return endcoords
end

local function pickUpShell(id)
	table.insert(PICKED_UP, SHELL[id])

	-- TODO: remove
	print(id)

	TriggerServerEvent("shell:take", id)

	notify(Translation[Config.Translation].takeshell)
end

local function lowestValue(t)
	local k

	for i, v in pairs(t) do
		k = k or i
		if v < t[k] then
			k = i
		end
	end

	return k
end

local function labMenu() -- TODO: QBCore implementation
	if #PICKED_UP ~= 0 then
		local elements = {}

		for i = 1, #PICKED_UP do
			table.insert(
				elements,
				{
					label = Translation[Config.Translation].shell ..
						" [" .. tostring(PICKED_UP[i].id) .. "]",
					value = PICKED_UP[i].id
				}
			)
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open(
			"default",
			GetCurrentResourceName(),
			"luski",
			{
				title = (Translation[Config.Translation].lab),
				align = "center",
				elements = elements
			},
			function(data, menu)
				for i = 1, #PICKED_UP do
					if tostring(PICKED_UP[i].id) == tostring(data.current.value) then
						ESX.UI.Menu.Open(
							"dialog",
							GetCurrentResourceName(),
							"opis",
							{
								title = Translation[Config.Translation].description
							},
							function(data2, menu2)
								if string.len(data2.value) >= 5 and string.len(data2.value) <= 30 then
									TriggerServerEvent(
										"shell:give",
										PICKED_UP[i].weapon,
										PICKED_UP[i].when,
										PICKED_UP[i].hour,
										PICKED_UP[i].minute,
										PICKED_UP[i].ispolice,
										PICKED_UP[i].id,
										data2.value
									)
									notify(Translation[Config.Translation].giveshell)
									table.remove(PICKED_UP, i)
								else
									notify(Translation[Config.Translation].descriptionerror)
								end
								menu2.close()
							end,
							function(_, menu2)
								menu2.close()
							end
						)
						menu.close()
					end
				end
			end,
			function(_, menu)
				menu.close()
			end
		)
	else
		notify(Translation[Config.Translation].noshells)
	end
end

local function closetMenu(info)
	local elements = {}

	for shell, _ in pairs(info) do
		table.insert(
			elements,
			{
				label = Translation[Config.Translation].shell ..
					" [" .. tostring(shell) .. "]",
				value = shell
			}
		)
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		"default",
		GetCurrentResourceName(),
		"szafka_luski",
		{
			title = (Translation[Config.Translation].docs),
			align = "center",
			elements = elements
		},
		function(data, menu)
			for shell, x in pairs(info) do
				if shell == data.current.value then
					local elements2 = {}

					table.insert(elements2, {label = x["weapon"], value = "weapon"})
					table.insert(elements2, {label = x["timee"], value = "date"})

					if tostring(x["ispolice"]) == "true" then
						table.insert(
							elements2,
							{label = Translation[Config.Translation].police, value = "ispolice"}
						)
					else
						table.insert(
							elements2,
							{label = Translation[Config.Translation].civil, value = "ispolice"}
						)
					end

					table.insert(elements2, {label = x["description"], value = "desc"})
					table.insert(
						elements2,
						{label = Translation[Config.Translation].delete, value = "delete"}
					)

					ESX.UI.Menu.Open(
						"default",
						GetCurrentResourceName(),
						"info_luska",
						{
							title = (Translation[Config.Translation].shell .. " [" .. shell .. "]"),
							align = "center",
							elements = elements2
						},
						function(data2, menu2)
							if data2.current.value == "delete" then
								TriggerServerEvent("shell:delete", shell)
								menu2.close()
							end
						end,
						function(_, menu2)
							menu2.close()
						end
					)
					menu.close()
				end
			end
		end,
		function(_, menu)
			menu.close()
		end
	)
end

--[[
	THREADS
--]]
CreateThread(
	function()
		local triggered

		while true do
			if tonumber(SELECTED_WEAPON) == -1951375401 then
				if IsPlayerFreeAiming(ID) then
					if #SHELL ~= 0 then
						Wait(4)

						SHELLS_ON_SCREEN = {}
						COUNTER = 0

						for i = 1, #SHELL do
							if SHELL[i] ~= nil then
								local objectcoords = SHELL[i].coords
								local playercoords = GetEntityCoords(PID)
								if #(playercoords - objectcoords) < 3.5 then
									local _, zcord =
										GetGroundZFor_3dCoord(
										objectcoords.x,
										objectcoords.y,
										objectcoords.z,
										1
									)
									local camcord = getCamCoords()

									if camcord ~= nil then
										local coordszcord =
											vector3(objectcoords.x, objectcoords.y, zcord + 0.2)
										local camdist = #(camcord - coordszcord)

										if camdist < 1.0 then
											table.insert(SHELLS_ON_SCREEN, camdist)

											local lowest = SHELLS_ON_SCREEN[lowestValue(SHELLS_ON_SCREEN)]

											if camdist == lowest then
												if tonumber(COUNTER) == 0 then
													COUNTER = 1
													triggered = i
													DrawMarker(
														28,
														coordszcord,
														0.0,
														0.0,
														0.0,
														0.0,
														0.0,
														0.0,
														0.02,
														0.02,
														0.02,
														189,
														14,
														4,
														140,
														false,
														true,
														2,
														nil,
														nil,
														false
													)
												else
													DrawMarker(
														28,
														coordszcord,
														0.0,
														0.0,
														0.0,
														0.0,
														0.0,
														0.0,
														0.02,
														0.02,
														0.02,
														237,
														255,
														14,
														140,
														false,
														true,
														2,
														nil,
														nil,
														false
													)
												end
											else
												DrawMarker(
													28,
													coordszcord,
													0.0,
													0.0,
													0.0,
													0.0,
													0.0,
													0.0,
													0.02,
													0.02,
													0.02,
													237,
													255,
													14,
													140,
													false,
													true,
													2,
													nil,
													nil,
													false
												)
											end
											if IsControlJustReleased(0, 38) then
												if not PICKED then
													PICKED = true
													pickUpShell(triggered)
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
	end
)

CreateThread(
	function()
		while true do
			Wait(100)

			if PICKED then
				Wait(1500)
				PICKED = false
			end
		end
	end
)

-- RETURN SHELL MARKER

CreateThread(
	function()
		while true do
			Wait(4)

			local MarkerDist = #(GetEntityCoords(PID) - Config.LabCoordsGive)

			if MarkerDist < 9.0 then
				DrawMarker(
					1,
					Config.LabCoordsGive,
					0.0,
					0.0,
					0.0,
					0.0,
					0.0,
					0.0,
					1.0,
					1.0,
					0.7,
					237,
					255,
					14,
					140,
					false,
					true,
					2,
					nil,
					nil,
					false
				)

				if MarkerDist < 1.1 then
					if Config.FrameWork.ESX then
						ESX.ShowHelpNotification(Translation[Config.Translation].pressgive)
					elseif Config.FrameWork.QBCore then
					-- TODO: QBCore implementation
					end
				end
			else
				Wait(1500)
			end
		end
	end
)

-- CLOSET MARKER
CreateThread(
	function()
		while true do
			Wait(4)

			local MarkDist = #(GetEntityCoords(PID) - Config.LabCoordsCloset)

			if MarkDist < 9.0 then
				DrawMarker(
					1,
					Config.LabCoordsCloset,
					0.0,
					0.0,
					0.0,
					0.0,
					0.0,
					0.0,
					1.0,
					1.0,
					0.7,
					237,
					255,
					14,
					140,
					false,
					true,
					2,
					nil,
					nil,
					false
				)

				if MarkDist < 1.1 then
					if Config.FrameWork.ESX then
						ESX.ShowHelpNotification(Translation[Config.Translation].pressopen)
					elseif Config.FrameWork.QBCore then
					-- TODO: QBCore implementation
					end
				end
			else
				Wait(1500)
			end
		end
	end
)

--[[
COMMANDS
--]]
RegisterCommand(
	"openlabsm",
	function()
		if #(GetEntityCoords(PID) - Config.LabCoordsGive) < 1.1 then
			labMenu()
		end
		
		if #(GetEntityCoords(PID) - Config.LabCoordsCloset) < 1.1 then
			TriggerServerEvent("shell:getinfo")
		end
	end,
	false
)

RegisterKeyMapping(
	"openlabsm",
	Translation[Config.Translation].binddesc,
	"keyboard",
	"E"
)

--[[
	EVENTS
--]]
RegisterNetEvent(
	"shell:get",
	function(l)
		SHELL = l
	end
)

RegisterNetEvent(
	"shell:getinfos",
	function(get)
		closetMenu(get)
	end
)
--[[
AddEventHandler('gameEventTriggered', function(ev, inf)
	if ev == 'CEventNetworkEntityDamage' then
		print(ev,table.unpack(inf))
	end
	if ev == "CEventDamage" then
		print(ev,table.unpack(inf))
	end
	if ev == "CEventEntityDamaged" then
		print(ev,table.unpack(inf))
	end
	if ev == "CEventDataFileMounter" then
		print(ev,table.unpack(inf))
	end
	if ev == "CEventDataDecisionMaker" then
		print(ev,table.unpack(inf))
	end
	if ev == "CEventInfo" then
		print(ev,table.unpack(inf))
	end
	print(ev)
end)
--]]
