local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}

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
	
	CreateBlip()	
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    CreateBlip()	
	Citizen.Wait(5000)
end)

--------------------------------------
local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0


local PackageObject = nil
local currentPackages = 0
local packageObjectModel = "prop_cs_cardbox_01"
local packageObjectHash = GetHashKey(packageObjectModel)
local jobVehicle = "boxville4"
local jobVehicleHash = GetHashKey(jobVehicle)
local packagesToTake = {}
local deliveryVehicleId = nil
local isDeliveringPackage = false
local hasPackageToDeliver = false
local mustReturnToVehicle = false
local jobDestination = nil
local jobVehicleId = nil
local playerIsCarring = nil -- Carton actuellement porté par le joueur
local locations = {
	["Grapeseed"] = {
		['Max'] = 22,
		[1] = {2563.99, 4692.7, 35.02},
		[2] = {1967.33, 4640.92, 41.88},
		[3] = {2030.39, 4980.46, 42.1},
		[4] = {1717.86, 4676.93, 43.66},
		[5] = {1689.25, 4818.3, 43.06},
		[6] = {2505.48, 4095.73, 39.2}, 
		[7] = {2570.87, 4282.84, 43.0},
		[8] = {2721.19, 4285.98, 48.6},
		[9] = {2727.59, 4145.46, 45.69},
		[10] = {3322.6, 5166.06, 19.92},
		[11] = {2216.42, 5612.49, 55.69}, 
		[12] = {2434.51, 4976.82, 47.07},
		[13] = {2300.36, 4871.94, 42.06},
		[14] = {1962.36, 5184.98, 47.98},
		[15] = {1698.97, 4921.18, 42.56},
		[16] = {1655.87, 4874.38, 42.04}, 
		[17] = {2159.72, 4789.8, 41.67},
		[18] = {2121.77, 4784.71, 41.97},
		[19] = {2639.04, 4246.56, 44.77},
		[20] = {2455.85, 4058.3, 38.06},
		[21] = {3680.06, 4497.93, 25.11}, 
		[22] = {3807.8, 4478.6, 6.37},
	},

	["Sandy Shores"] = {
		['Max'] = 33,
		[1] = {1986.69824, 3815.02490, 33.32370},
		[2] = {1446.34997, 3649.69384, 35.48260},
		[3] = {228.27, 3165.8, 43.61},
		[4] = {170.36, 3113.28, 43.51},
		[5] = {179.76, 3033.1, 43.98},
		[6] = {1990.57141, 3057.46801, 48.06378}, 
		[7] = {2201.01, 3318.25, 46.77},
		[8] = {2368.38, 3155.96, 48.61},
		[9] = {1881.07,3888.5,34.25},
		[10] = {1889.76,3810.71,33.75},
		[11] = {1638.8,3734.17,34.41}, 
		[12] = {2630.27,3262.88,56.25},
		[13] = {2622.43,3275.56,56.3},
		[14] = {2633.7,3287.4,56.45},
		[15] = {2389.48, 3341.64, 47.72}, 
		[16] = {2393.01, 3320.62, 48.24},
		[17] = {2163.38, 3374.63, 46.07},
		[18] = {1959.95, 3741.99, 33.24},
		[19] = {1931.55, 3727.6, 33.84},
		[20] = {1850.68, 3690.03, 35.5}, 
		[21] = {1707.92, 3585.29, 36.57},
		[22] = {1756.33, 3659.54, 35.39},
		[23] = {1825.41, 3718.35, 34.42},
		[24] = {1899.13, 3764.68, 33.79},
		[25] = {1923.37, 3797.43, 33.44}, 
		[26] = {1914.69, 3813.37, 33.44},
		[27] = {1913.61, 3868.06, 33.37},
		[28] = {1942.34, 3885.42, 33.67},
		[29] = {1728.66, 3851.46, 34.78},
		[30] = {903.67, 3560.82, 33.81},
		[31] = {910.93, 3644.29, 32.68},
		[32] = {1393.15,3673.4, 34.79},
		[33] = {1435.18, 3682.92, 34.84},
	},

	["Paleto Bay"] = {
		['Max'] = 29,
		[6] = {-215.5, 6431.99, 32.49}, 
		[7] = {-46.21,6595.62,31.55},
		[8] = {0.46, 6546.92, 32.37},
		[9] = {-1.09, 6512.9, 33.04},
		[10] = {99.35, 6618.56, 33.47},
		[11] = {-774.31, 5597.84, 34.61}, 
		[12] = {-696.1, 5802.36, 17.83},
		[13] = {-448.77, 6009.95, 32.22},
		[14] = {-326.55,6083.95,31.96},
		[15] = {-341.66, 6212.46,32.59},
		[16] = {-247.15,6331.02,32.93}, 
		[17] = {-394.74,6272.52,30.94},
		[18] = {35.18,6662.39,32.19},
		[19] = {-130.66,6551.98,29.87},
		[20] = {-106.06,6469.6,32.63},
		[21] = {-94.5, 6408.86, 32.14}, 
		[22] = {-25.2,6472.25,31.98},
		[23] = {-105.28,6528.96,30.17},
		[24] = {150.41,6647.58,32.11},
		[25] = {161.68,6636.1,32.17},
		[26] = {-9.37,6653.93,31.98},
		[27] = {-40.15,6637.23,31.09},
		[28] = {-5.97,6623.07,32.32},
		[29] = {-113.22, 6538.18, 30.6},
	}
}

local restockLocationPoint = { -441.282, 6142.714, 30.478 }

local restockLocations = {
 {x = -436.062, y = 6135.071, z = 30.528},
 {x = -435.247, y = 6134.340, z = 30.528},
 {x = -434.869, y = 6133.323, z = 30.528},
 {x = -444.338, y = 6138.739, z = 30.528},
 {x = -445.607, y = 6139.875, z = 30.528},
 {x = -427.392, y = 6134.616, z = 30.528},
 {x = -426.332, y = 6133.624, z = 30.528},
 {x = -424.201, y = 6132.655, z = 30.528},
 {x = -440.002, y = 6134.742, z = 30.528},
 {x = -442.251, y = 6135.758, z = 30.528},
 {x = -443.782, y = 6137.115, z = 30.528},
 {x = -446.922, y = 6141.104, z = 30.528},
 {x = -448.367, y = 6143.311, z = 30.528},
 {x = -434.094, y = 6131.830, z = 30.528},
 {x = -430.602, y = 6124.309, z = 30.528},
 {x = -428.683, y = 6125.653, z = 30.528},
 {x = -420.742, y = 6132.365, z = 30.528},
 {x = -427.465, y = 6136.437, z = 30.528},
}

local vehicleSpawnLocations = {
 {x = -400.5178, y = 6163.97607, z = 31.387895, h = 354.08728},
 {x = -403.4285, y = 6165.96875, z = 31.426778, h = 352.25277},
 {x = -406.0371, y = 6168.61914, z = 31.394813, h = 353.80203},
 {x = -408.9385, y = 6171.53271, z = 31.380252, h = 353.44647},
 {x = -411.9129, y = 6174.58349, z = 31.379669, h = 353.77667}
}



function CreateBlip()
    if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' then

		if BlipCloakRoom == nil then
			BlipCloakRoom = AddBlipForCoord(-413.98, 6171.48, 31.48)
			SetBlipSprite(BlipCloakRoom, 632)
			SetBlipColour(BlipCloakRoom, 5)
			SetBlipAsShortRange(BlipCloakRoom, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('(1) Veículo de Trabalho')
			EndTextCommandSetBlipName(BlipCloakRoom)
		end
		if BlipPickRoom == nil then
			BlipPickRoom = AddBlipForCoord(-439.89, 6146.42, 31.48)
			SetBlipSprite(BlipPickRoom, 632)
			SetBlipColour(BlipPickRoom, 2)
			SetBlipAsShortRange(BlipPickRoom, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('(2) Carregar Carrinha')
			EndTextCommandSetBlipName(BlipPickRoom)
	    end		
	  
	else

        if BlipCloakRoom ~= nil then
            RemoveBlip(BlipCloakRoom)
            BlipCloakRoom = nil
		end
		if BlipPickRoom ~= nil then
            RemoveBlip(BlipPickRoom)
            BlipPickRoom = nil
        end
	end
end

--[[ #########################################################################
Thread loop on vehicle driving
######################################################################### ]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' and isInVehicle and currentSeat == -1 and playerIsOnJobVehicle() then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)

			if jobDestination then -- Si il y a une destination
				local distanceToDelivery = GetDistanceBetweenCoords(playerCoords, jobDestination.x, jobDestination.y, jobDestination.z, true)
				if distanceToDelivery < 30 then
					drawTxt('Descend de la [~g~ camionette ~s~] pour [~b~ livrer ~s~] le [~g~ colis ~s~]')
				end
			end
			-- Récupération de paquets
			local distanceBetweenPackagesStock = GetDistanceBetweenCoords(playerCoords, restockLocationPoint[1], restockLocationPoint[2], restockLocationPoint[3], true)
			if distanceBetweenPackagesStock < 40 then
				DrawMarker(1,  restockLocationPoint[1], restockLocationPoint[2], restockLocationPoint[3], 0,0,0,0,0,0,4.0,4.0,0.3,255,255,0,165,0,0,0,true)
				if(distanceBetweenPackagesStock < 4) then
					DrawText3d( restockLocationPoint[1], restockLocationPoint[2], restockLocationPoint[3]+1.2, "Appuie sur [~g~ E ~s~] pour [~g~réapprovisionner la camionnette~s~]", 200)
					if IsControlJustPressed(0, 38) then
						local vehicleId = GetVehiclePedIsIn(playerPed)
						local plate = GetVehicleNumberPlateText(vehicleId)
						ESX.TriggerServerCallback('gopostal:getLimitPackage', function(limit)
							if limit > 0 then
								if #packagesToTake == 0 then
									TaskLeaveVehicle(playerPed, vehicleId, 1)
									LoadingPackagesIntoTruck(vehicleId, plate, limit)
								else
									ESX.ShowNotification('~r~Tu as déjà des ~y~paquets~r~ à récuperer.')
								end
							else
								ESX.ShowNotification('~r~La camionette est pleine.')
							end
						end, plate)
					end
				end
			end
		end
	end
end)

--[[ #########################################################################
Thread loop on player is walking
######################################################################### ]]--

Citizen.CreateThread(function()
	while true do
		local waitTime = 1000
		if not isInVehicle then
			if #packagesToTake ~= 0 then -- Si le joueur a des paquets à charcer
				local playerPed = PlayerPedId()
				local pedCoords = GetEntityCoords(playerPed,true)
				if carryingPackage == nil then -- Si le joueur ne porte pas de carton
					for _, package in pairs(packagesToTake) do
						local pkgCoords = GetEntityCoords(package)
						DrawMarker(2, pkgCoords.x, pkgCoords.y, pkgCoords.z+0.40, 0,0,0,180.0,0,0,0.3,0.3,0.3,255,255,0,165,0,0,0,true)
						if GetDistanceBetweenCoords(pedCoords, pkgCoords, true) < 1.2 then -- Si on es proche d'un colis
							drawTxt('Appuie sur [~y~ E ~s~] pour prendre un [~y~ colis ~s~]')
							if IsControlJustPressed(0, 38) then -- Si le joueur a appuyer sur E
								-- On fait l'animation de récupération du colis
								LoadDict('random@domestic')
								LoadDict("anim@heists@box_carry@")
								TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8.0, -1,	 0, 0.0, 0, 0, 0)
								Citizen.Wait(550)
								AttachEntityToEntity(package, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
								Citizen.Wait(550)
								TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
								carryingPackage = package
							end
						end
					end
				else -- Si le joueurs est en train de porter un carton
					local vehicleCoords = GetEntityCoords(deliveryVehicleId)
					local plate = GetVehicleNumberPlateText(deliveryVehicleId)
					DrawMarker(2, vehicleCoords["x"],vehicleCoords["y"],vehicleCoords["z"]+2.8, 0,0,0,180.0,0,0,1.5,1.5,1.5,0,255,0,165,0,0,0,true)
					local closecar = GetClosestVehicle(pedCoords, 3.0, 0, 71)
					if closecar and IsVehicleModel(closecar, jobVehicleHash) and GetVehicleNumberPlateText(closecar) == plate then -- Si le joueurs est a côté d'une camionette
						drawTxt('Appuie sur [~y~ E ~s~] pour déposer un colis dans [~g~ la camionette ~s~]')
						if IsControlJustPressed(0, 38) then 
							ESX.TriggerServerCallback('gopostal:addPackage', function(result)
								if result then
									-- Si la camionette n'est pas pleine
									DeleteObject(carryingPackage)
									ClearPedTasks(playerPed)
									table.removeByValue(packagesToTake, carryingPackage)
									carryingPackage = nil
									if #packagesToTake == 0 then
										ESX.ShowNotification('[~y~Camionette chargée~s~] [~g~Tu peux commencer la livraison~s~]')
									end
								else
									ESX.ShowNotification('~r~La camionette est pleine !')
									-- Si la camionette est pleine
								end
							end, plate)
						end
					end
				end
				waitTime = 5
			elseif mustReturnToVehicle and #packagesToTake == 0 then -- Si le joueur doit retourné à son véhicule
				local vehicleCoords = GetEntityCoords(deliveryVehicleId)
				DrawMarker(2, vehicleCoords["x"], vehicleCoords["y"], vehicleCoords["z"]+2.8, 0,0,0,180.0,0,0,1.5,1.5,1.5,0,255,0,165,0,0,0,true)
				drawTxt('Retourne dans la [~g~ camionette ~s~]')
				waitTime = 5
			elseif isDeliveringPackage then -- Si le joueur est en phase de distribution d'un colis
				local playerPed = PlayerPedId()
				local playerCoords = GetEntityCoords(playerPed, true)
				if hasPackageToDeliver then -- Si le joueur a un colis en mains
					local distanceToDelivery = GetDistanceBetweenCoords(playerCoords, jobDestination.x, jobDestination.y, jobDestination.z, true)
					DrawMarker(2, jobDestination.x, jobDestination.y, jobDestination.z, 0,0,0,180.0,0,0,0.5,0.5,0.5,0,0,255,165,0,0,0,true)
					if distanceToDelivery < 1.5 then
						drawTxt('Appuie sur [~g~ E ~s~] pour [~g~ déposer ~s~] le [~g~ colis ~s~]')
						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback('gopostal:deliverPackage', function(result)
								DeleteObject(PackageObject)
								ClearPedTasks(playerPed)
								RemoveJobBlip()
								PackageObject = nil 
								mustReturnToVehicle = true
								hasPackageToDeliver = false
								isDeliveringPackage = false
								jobDestination = nil
							end, GetVehicleNumberPlateText(deliveryVehicleId))
						end
					else
						drawTxt('Va [~g~ déposer ~s~] le [~g~ colis ~s~] à [~b~ destination ~s~]')
					end


				else -- Si le joueur n'a pas de colis en mains
					local vehicleCoords = GetEntityCoords(deliveryVehicleId)
					local distanceToVehicle = GetDistanceBetweenCoords(playerCoords, vehicleCoords, true)
					DrawMarker(2, vehicleCoords["x"], vehicleCoords["y"], vehicleCoords["z"]+2.8, 0,0,0,180.0,0,0,1.5,1.5,1.5,0,255,0,165,0,0,0,true)
					if distanceToVehicle < 3 then
						drawTxt('Appuie sur [~g~ E ~s~] pour [~g~ prendre ~s~] le [~g~ colis ~s~]')
						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback('gopostal:takePackage', function(result)
								if result then
									hasPackageToDeliver = true
									PackageObject = CreateObject(packageObjectHash, playerCoords, true, true, true)
									AttachEntityToEntity(PackageObject, playerPed, GetPedBoneIndex(playerPed,  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
									LoadAnim("anim@heists@box_carry@")
									TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
								end
							end, GetVehicleNumberPlateText(deliveryVehicleId))
						end
					else
						drawTxt('Va vers la [~g~ camionette ~s~] pour [~g~ prendre ~s~] le [~g~ colis ~s~]')
					end
				end
				waitTime = 5
			end
		end
		Citizen.Wait(waitTime)
	end
end)

function LoadingPackagesIntoTruck(vehicleId, plate, limit)
	local playerPed 	    = PlayerPedId()
	local vehicleCoords 	= GetEntityCoords(vehicleId)
	ESX.ShowNotification('Récupère les ~y~colis~s~ pour les mettre dans ~b~la camionette~s~.')
	carryingPackage = nil
	
	local availableLocations = {table.unpack(restockLocations)}
	for i=1, limit, 1 do -- On créer les paquets
		local location = availableLocations[ math.random( #availableLocations ) ]
		local packageObjectId = CreateObject(packageObjectHash, location.x, location.y, location.z, true, true, true)
		table.insert(packagesToTake, packageObjectId) 
		PlaceObjectOnGroundProperly(packageObjectId)
		FreezeEntityPosition(packageObjectId, true)
		table.removeByValue(availableLocations, location)
	end
	deliveryVehicleId = vehicleId
end



-- Défini la destination de livraison et le vehicule de livraison
-- Si une livraison est déjà en cours pour le véhicule, il affiche la même
function setDeliveryDestination(vehicleId, plate)
	ESX.TriggerServerCallback('gopostal:requestDeliveryMission', function(deliveryDestination)

		SetJobBlip(deliveryDestination.x, deliveryDestination.y, deliveryDestination.z)
		
		deliveryVehicleId = vehicleId
		jobDestination = deliveryDestination
	end, plate)
end


function playerEnterVehicle(vehicleId)
	if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' then
		local playerPed = PlayerPedId()
		local currentSeat = GetPedVehicleSeat(playerPed)
		local model = GetEntityModel(vehicleId)
		local name = GetDisplayNameFromVehicleModel()
		local netId = VehToNet(vehicleId)
		if carryingPackage ~= nil then -- Le joueur a un paquet en main
			DeleteObject(carryingPackage)
			table.removeByValue(packagesToTake, carryingPackage)
			carryingPackage = nil
		end
		if #packagesToTake > 0 then -- Il y a encore des paquets à prendre
			for _, package in pairs(packagesToTake) do
				DeleteObject(package)
			end
			packagesToTake = {}
		end

		local plate = GetVehicleNumberPlateText(vehicleId)

		ESX.TriggerServerCallback('gopostal:getPackages', function(currentPackages)
			local comeback = ( isDeliveringPackage and mustReturnToVehicle )
			if hasPackageToDeliver then hasPackageToDeliver = false end
			if mustReturnToVehicle then mustReturnToVehicle = false end
			if isDeliveringPackage then isDeliveringPackage = false end
			if currentPackages > 0 then -- Le joueur entre dans un véhicule qui contient des colis
				if jobDestination == nil then
					setDeliveryDestination(vehicleId, plate)
					-- Si la destination n'est pas encore définie
				end
			else -- Le joueur entre dans un véhicule qui ne contient pas de colis
				if comeback then
					ESX.ShowNotification('~g~Retourne a tes occupations bonhomme !') -- RETOUR AU QG
				end
			end
			
		end, plate)
	end
end

function playerExitVehicle(vehicleId)
	if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' then
		if jobDestination then -- Si le joueur est cours en livraison
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local distanceToDelivery = GetDistanceBetweenCoords(playerCoords, jobDestination.x, jobDestination.y, jobDestination.z, true)
			if distanceToDelivery < 30 then -- Si la distance avec le point de livraison est inferieur à 30
				deliveryVehicleId = vehicleId
				isDeliveringPackage = true
				ESX.ShowNotification('Tu es descendu donc tu peux livrer')
			else -- Sinon on dit au joueur de remonter dans son véhicule
				mustReturnToVehicle = true
			end
		end
	end
end

--[[
####################################################################################################
Gestion entrée / sortie véhicule
####################################################################################################
]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if not isInVehicle and not IsPlayerDead(PlayerId()) then
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not isEnteringVehicle then
				-- Le joueur est en train d'entrer dans un véhicule
				isEnteringVehicle = true
			elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
				-- Le joueur a annuler son entrée dans le véhicule
				isEnteringVehicle = false
			elseif IsPedInAnyVehicle(playerPed, false) then
				-- Le joueur est entré dans le véhicule
				isEnteringVehicle = false
				isInVehicle = true
				currentVehicle = GetVehiclePedIsUsing(playerPed)
				currentSeat = GetPedVehicleSeat(playerPed)
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				playerEnterVehicle(currentVehicle)

				--TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
				-- Le joueur est sorti du véhicule
				local model = GetEntityModel(currentVehicle)
				local name 	= GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				playerExitVehicle(currentVehicle)
				--TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
				isInVehicle = false
				currentVehicle = 0
				currentSeat = 0
			end
		end
		Citizen.Wait(50)
	end
end)