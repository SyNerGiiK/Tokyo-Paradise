------------------CONFIG----------------------
local startX = 1444.51 -- miejsce lapania kurczakow
local startY = 1078.75
local startZ = 115.33
---------------------------------------------

local chickenToCapture = {}
---------------------------------------------
--------tego lepiej nie ruszaj ponizej-------
---------------------------------------------
local totalOfChickens = 0
local currentCapture = nil
local onReselling, onTreatment, onPackaging = false, false, false
local packages = 0
local PlayerData = {}
local farmBlip, treatmentBlip, deliveryBlip = 0, 0, 0
--------------
local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

function deleteBlips()
    RemoveBlip(farmBilp)
    RemoveBlip(treatmentBlip)
    RemoveBlip(deliveryBlip)
end
function refreshBlips()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil and PlayerData.job.name == "chickenfarm" then
        local farmBilp = AddBlipForCoord(Config.farm[1].pointX, Config.farm[1].pointY, Config.farm[1].pointZ)
        SetBlipSprite(farmBilp, 126)
        SetBlipDisplay(farmBilp, 4)
        SetBlipScale(farmBilp, 1.0)
        SetBlipColour(farmBilp, 61)
        SetBlipAsShortRange(farmBilp, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('blip_harvest'))
        EndTextCommandSetBlipName(farmBilp)
        local treatmentBlip = AddBlipForCoord(Config.treatment[1].pointX, Config.treatment[1].pointY, Config.treatment[1].pointZ)
        SetBlipSprite(treatmentBlip, 154)
        SetBlipDisplay(treatmentBlip, 4)
        SetBlipScale(treatmentBlip, 1.0)
        SetBlipColour(treatmentBlip, 61)
        SetBlipAsShortRange(treatmentBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('blip_treatment'))
        EndTextCommandSetBlipName(treatmentBlip)
        local deliveryBlip = AddBlipForCoord(Config.delivery[1].pointX, Config.delivery[1].pointY, Config.delivery[1].pointZ)
        SetBlipSprite(deliveryBlip, 479)
        SetBlipDisplay(deliveryBlip, 4)
        SetBlipScale(deliveryBlip, 0.8)
        SetBlipColour(deliveryBlip, 61)
        SetBlipAsShortRange(deliveryBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('blip_resell'))
        EndTextCommandSetBlipName(deliveryBlip)
	end
end

---
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) PlayerData = xPlayer end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(0, 0, 0, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 255, 255, 255, 175)
end

-------Przerabianie
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local needWait = true
        if PlayerData.job ~= nil and PlayerData.job.name == "chickenfarm" then
            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
            for _, farm in pairs(Config.farm) do
                local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, farm.pointX, farm.pointY, farm.pointZ)
                if distance <= 25.0 then
                    DrawMarker(27, farm.pointX, farm.pointY, farm.pointZ - 0.97, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
                    if distance <=2.5 then
                        DrawText3D(farm.pointX, farm.pointY, farm.pointZ, _U('start_harvest_chicken'))
                    end
                    if distance <= 0.5 then
                        if IsControlJustPressed(0, Keys['E']) then
                            startFarmChicken(farm)
                        end
                    end
                    needWait = false
                end
            end
            for _, treatment in pairs(Config.treatment) do
                local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, treatment.pointX, treatment.pointY, treatment.pointZ)
                if distance <= 25.0 then
                    DrawMarker(27, treatment.pointX, treatment.pointY, treatment.pointZ - 0.97, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
                    if distance <=2.5 then
                        DrawText3D(treatment.pointX, treatment.pointY, treatment.pointZ, _U('start_treatment_chicken'))
                    end
                    if distance <= 0.5 then
                        if IsControlJustPressed(0, Keys['E']) then
                            TreatmentTheChicken(treatment)
                        end
                    end
                    needWait = false
                end
            end
            for _, packaging in pairs(Config.packaging) do
                local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, packaging.pointX, packaging.pointY, packaging.pointZ)
                if distance <= 25.0 then
                    DrawMarker(27, packaging.pointX, packaging.pointY, packaging.pointZ - 0.97, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
                    if distance <=2.5 and packages == 0 then
                        DrawText3D(packaging.pointX, packaging.pointY, packaging.pointZ, _U('packing_chicken_trays'))
                    elseif distance <= 2.5 and packages == 1 then
                        DrawText3D(packaging.pointX, packaging.pointY, packaging.pointZ, _U('stop_packing_chicken_trays'))
                        DrawText3D(packaging.pointX, packaging.pointY, packaging.pointZ + 0.1, _U('continue_packing_chicken_trays'))
                    end
                    if distance <= 0.5 then
                        if IsControlJustPressed(0, Keys['E']) then
                            PackTheChicken(packaging)
                        elseif IsControlJustPressed(0, Keys['G']) then
                            StopPackTheChicken(packaging)
                        end
                    end
                    needWait = false
                end
            end
            for _, delivery in pairs(Config.delivery) do
                local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, delivery.pointX, delivery.pointY, delivery.pointZ)
                if distance <= 25.0 then
                    DrawMarker(27, delivery.pointX, delivery.pointY, delivery.pointZ - 0.97, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
                    if distance <=2.5 then
                        DrawText3D(delivery.pointX, delivery.pointY, delivery.pointZ, _U('start_delivery_chicken'))
                    end
                    if distance <= 0.5 then
                        if IsControlJustPressed(0, Keys['E']) then
                            SellChicken(delivery)
                        end
                    end
                    needWait = false
                end
            end
        else
            if needWait then 
                Citizen.Wait(1500) 
            end
        end
    end
end)
------

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function startFarmChicken(farm)
	-- Impossible si trop d'item sur soitalive_chicken
	local playerID = PlayerPedId()
    local inventory = ESX.GetPlayerData().inventory
	local aliveChickenCount = 0
	local aliveChickenLimit = 0
    for i = 1, #inventory, 1 do
        if inventory[i].name == 'alive_chicken' then
			aliveChickenCount = inventory[i].count
			aliveChickenLimit = inventory[i].limit
        end
	end
	if aliveChickenLimit == aliveChickenCount then
		ESX.ShowNotification(_U('unable_capture_chicken_invfull'))
	else
		local numberOfChickens = farm.numberOfChickens
		if farm.numberOfChickens > (aliveChickenLimit - aliveChickenCount) then
			numberOfChickens = farm.numberOfChickens - (aliveChickenLimit - aliveChickenCount)
		end
		DoScreenFadeOut(500)
		Citizen.Wait(500)
		SetEntityCoordsNoOffset(playerID, farm.spawnX, farm.spawnY, farm.spawnZ, 0, 0, 1)
		RequestModel(GetHashKey('a_c_hen'))
		while not HasModelLoaded(GetHashKey('a_c_hen')) do Wait(1) end
		for i = 1, numberOfChickens do
			xVariation = randomFloat(-4,4)
			yVariation = randomFloat(-4,4)
			chicken = CreatePed(26, "a_c_hen", farm.spawnX + xVariation, farm.spawnY + yVariation, farm.spawnZ, 0.0, true, false)
			TaskReactAndFleePed(chicken, playerID)
			table.insert(chickenToCapture, chicken)
		end
		Citizen.Wait(500)
		DoScreenFadeIn(500)
		currentCapture = farm
	end
end

function StopFarmChicken(farm)
	local playerID = PlayerPedId()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoordsNoOffset(playerID, farm.pointX, farm.pointY, farm.pointZ, 0, 0, 1)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
    local needVehicleDeposit = true
    local x, y, z = table.unpack(GetEntityCoords(playerID))
    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, playerID, GetPedBoneIndex(playerID, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
    packages = 0
    while needVehicleDeposit do
        Citizen.Wait(250)
        local vehicle = ESX.Game.GetVehicleInDirection()
        local coords = GetEntityCoords(playerID)
        LoadDict('anim@heists@box_carry@')

        if not IsEntityPlayingAnim(playerID, "anim@heists@box_carry@", "idle", 3) and needVehicleDeposit == true then
            TaskPlayAnim(playerID, 'anim@heists@box_carry@', "idle",  3.0, -8, -1, 63, 0, 0, 0, 0)
        end

        if DoesEntityExist(vehicle) then
            needVehicleDeposit = false
            ESX.ShowNotification(_U('go_to_treatment'))
            LoadDict('anim@heists@narcotics@trash')
            TaskPlayAnim(playerID, 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0)
            Citizen.Wait(900)
            ClearPedTasks(playerID)
            DeleteEntity(prop)
			TriggerServerEvent("tost:wkladajKurczki", totalOfChickens)
			totalOfChickens = 0
        end
    end


end

function TreatmentTheChicken(treatment)
	
	local playerID = PlayerPedId()
    local inventory = ESX.GetPlayerData().inventory
    local aliveChickenCount = 0
    for i = 1, #inventory, 1 do
        if inventory[i].name == 'alive_chicken' then
            aliveChickenCount = inventory[i].count
        end
    end
    if aliveChickenCount > 0 and not onTreatment then
        onTreatment = true
		SetEntityCoords(playerID, treatment.pointX, treatment.pointY, treatment.pointZ-1)
		SetEntityHeading(playerID, treatment.playerHeading)
		chicken = CreateObject(GetHashKey('prop_int_cf_chick_01'), treatment.objX, treatment.objY, treatment.objZ, true, true, true)
		SetEntityRotation(chicken, 90.0, 0.0, treatment.objRot, 1, true)
        local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
        LoadDict(dict)
        FreezeEntityPosition(playerID, true)
        TaskPlayAnim(playerID, dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0)
        local PedCoords = GetEntityCoords(playerID)
        nozyk = CreateObject(GetHashKey('prop_knife'), PedCoords.x, PedCoords.y, PedCoords.z, true, true, true)
        AttachEntityToEntity(nozyk, playerID, GetPedBoneIndex(playerID, 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
        Citizen.Wait(5000)
		ESX.ShowNotification(_U('treatment_chicken_success'))
        FreezeEntityPosition(playerID, false)
        DeleteEntity(chicken)
        DeleteEntity(nozyk)
        ClearPedTasks(playerID)
        TriggerServerEvent("tostKurczaki:przerob", 1)
        onTreatment = false
    else
		ESX.ShowNotification(_U('no_engouht_alive_chicken'))
    end
end

function StopPackTheChicken(packaging)
	local playerID = PlayerPedId()
    FreezeEntityPosition(playerID, false)
    packsNeedInTheCar = true
    local x, y, z = table.unpack(GetEntityCoords(playerID))
    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, playerID, GetPedBoneIndex(playerID, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
    packages = 0
    while packsNeedInTheCar do
        Citizen.Wait(250)
        local vehicle = ESX.Game.GetVehicleInDirection()
        local coords = GetEntityCoords(playerID)
        LoadDict('anim@heists@box_carry@')

        if not IsEntityPlayingAnim(playerID, "anim@heists@box_carry@", "idle", 3) and packsNeedInTheCar == true then
            TaskPlayAnim(playerID, 'anim@heists@box_carry@', "idle",  3.0, -8, -1, 63, 0, 0, 0, 0)
        end

        if DoesEntityExist(vehicle) then
            packsNeedInTheCar = false
            ESX.ShowNotification(_U('go_to_resell'))
            LoadDict('anim@heists@narcotics@trash')
            TaskPlayAnim(playerID, 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0)
            Citizen.Wait(900)
            ClearPedTasks(playerID)
            DeleteEntity(prop)
        end
    end
end

function PackTheChicken(packaging)
	local playerID = PlayerPedId()
    local inventory = ESX.GetPlayerData().inventory
    local slaughteredChickenCount = 0
    for i = 1, #inventory, 1 do
        if inventory[i].name == 'slaughtered_chicken' then
            slaughteredChickenCount = inventory[i].count
        end
    end
    if slaughteredChickenCount > 0 and not onPackaging then
        onPackaging = true
		SetEntityCoords(playerID, packaging.pointX, packaging.pointY, packaging.pointZ-1)
		SetEntityHeading(playerID, packaging.playerHeading)
        local pCoords = GetEntityCoords(playerID)
		local meat = CreateObject(GetHashKey('prop_cs_steak'), pCoords.x, pCoords.y, pCoords.z, true, true, true)
		AttachEntityToEntity(meat, playerID, GetPedBoneIndex(playerID, 0x49D9), 0.15,
                             0.0, 0.01, 0.0, 0.0, 0.0, false, false, false,
                             false, 2, true)
        local karton = CreateObject(GetHashKey('prop_cs_clothes_box'), pCoords.x,	pCoords.y, pCoords.z, true, true, true)
        AttachEntityToEntity(karton, playerID,  GetPedBoneIndex(playerID, 57005), 0.13,
                             0.0, -0.16, 250.0, -30.0, 0.0, false, false, false,
                             false, 2, true)
        packages = 1
        LoadDict("anim@heists@ornate_bank@grab_cash_heels")
        TaskPlayAnim(playerID, "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
        FreezeEntityPosition(playerID, true)
        Citizen.Wait(6500)
        TriggerServerEvent("tostKurczaki:przerob", 2)
        ESX.ShowNotification(_U('packaging_chicken_success'))
        ClearPedTasks(playerID)
        DeleteEntity(karton)
        DeleteEntity(meat)
        onPackaging = false
    else
        ESX.ShowNotification(_U('no_engouht_slaughtered_chicken'))
    end
end

function SellChicken(delivery)
	local playerID = PlayerPedId()
    local inventory = ESX.GetPlayerData().inventory
    local packagedChickenCount = 0
    for i = 1, #inventory, 1 do
        if inventory[i].name == 'packaged_chicken' then
            packagedChickenCount = inventory[i].count
        end
    end
    if packagedChickenCount > 1 and not onReselling then
        ESX.TriggerServerCallback('drp_esxbridge:server:hasNpcRunCredit', function(canResellPackagedChicken) 
            if canResellPackagedChicken then
                onReselling = true
                SetEntityCoords(playerID, delivery.pointX, delivery.pointY, delivery.pointZ-1)
                SetEntityHeading(playerID, delivery.playerHeading)
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerID, 0.0, 0.9, -0.99))
                prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z, true, true, true)
                SetEntityHeading(prop, delivery.playerHeading)
                LoadDict('amb@medic@standing@tendtodead@idle_a')
                TaskPlayAnim(playerID, 'amb@medic@standing@tendtodead@idle_a','idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
                Citizen.Wait(6500)
                LoadDict('amb@medic@standing@tendtodead@exit')
                TaskPlayAnim(playerID, 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
                Citizen.Wait(1900)
                ClearPedTasks(playerID)
                DeleteEntity(prop)
                TriggerServerEvent("tostKurczaki:przerob", 3)
                onReselling = false
            else
                ESX.ShowNotification(_U('error_npcrun_limit'))
            end
        end, 10)
    else
        ESX.ShowNotification(_U('resell_chicken_failed'))
    end
end
-----
function LoadDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

		if currentCapture ~= nil then
			if #chickenToCapture > 0 then
				local playerID = PlayerPedId()
				for _, chickenID in pairs(chickenToCapture) do
					local chickenCoords = GetEntityCoords(chickenID)
					local plyCoords = GetEntityCoords(playerID, false)
					local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chickenCoords.x, chickenCoords.y, chickenCoords.z)
					if dist < 2 then
						DrawText3D(chickenCoords.x, chickenCoords.y,chickenCoords.z + 0.5, _U('capture_chicken'))
						if IsControlJustPressed(0, Keys['E']) then
							local successCapture = math.random(1, 100)
							LoadDict('random@domestic')
							TaskPlayAnim(GetPlayerPed(-1), 'random@domestic', 'pickup_low', 8.0, -8.0, -1,	 0, 0.0, 0, 0, 0)
							Citizen.Wait(600)
							if successCapture <= 60 then
								DeleteEntity(chickenID)
								table.remove(chickenToCapture, _)
								totalOfChickens = totalOfChickens + 1
								ESX.ShowNotification(_U('capture_chicken_success'))
							else
								ESX.ShowNotification(_U('capture_chicken_failed'))
							end
						end
					end
				end
			else
				StopFarmChicken(currentCapture)
				currentCapture = nil
			end
        else
            Citizen.Wait(500)
        end
    end
end)
