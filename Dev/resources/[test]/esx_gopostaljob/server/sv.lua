ESX 		= nil
MaxPackages = 18

local deliveryDestinations = {
	-- PALETO BAY
	{ x = -291.14, y = 6199.27, z = 32.49 },
	{ x = -96.43,  y = 6324.47, z = 32.08 },
	{ x = -390.28, y = 6300.23, z = 30.75 },
	{ x = -360.8,  y = 6320.98, z = 30.76 },
	{ x = -303.41, y = 6329.00, z = 32.99 },
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--base
local serverTruckDatabase = {}

	
RegisterServerEvent('gopostal:cash')
AddEventHandler('gopostal:cash', function(currentJobPay)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(currentJobPay)
		
	TriggerClientEvent("diablo_notes:sendNotification", _source, "Tu gagnes [~g~" .. currentJobPay .. "$~s~]", 5000)
end)	

ESX.RegisterServerCallback('gopostal:addPackage', function(source, cb, plate)
	local result = addPackageToVehicle(plate,1)
	cb(result)
end)

ESX.RegisterServerCallback('gopostal:takePackage', function(source, cb, plate)
	local result = removePackageFromVehicle(plate,1)
	cb(result)
end)

ESX.RegisterServerCallback('gopostal:getLimitPackage', function(source, cb, plate)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	cb(MaxPackages - vehicle.packages)
end)

ESX.RegisterServerCallback('gopostal:deliverPackage', function(source, cb, plate)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	vehicle.destination = nil
	TriggerEvent('drp_esxbridge:server:addSalaryFromNpcRun', GetPlayerIdentifier(source), 40, 20)
	TriggerClientEvent('esx:showNotification', source, 'Le colis a bien été livré et 40 € ont étés ajoutés à ta prochaine paie.')
	cb(true)
end)

ESX.RegisterServerCallback('gopostal:requestDeliveryMission', function(source, cb, plate)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	if vehicle.destination == nil then
		vehicle.destination = generateDeliveryDestination()
	end
	cb(vehicle.destination)
end)

ESX.RegisterServerCallback('gopostal:getPackages', function(source, cb, plate)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	cb(vehicle.packages)
end)


-- On ajoute un packet dans le véhicule
function addPackageToVehicle(plate, quantity)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	local totalOfPackages = vehicle.packages + quantity
	if MaxPackages < totalOfPackages then
		return false
	else
		setPackagesOfVehicleFromIndex(index, totalOfPackages)
		return true
	end
end

-- On retire un packet du véhicule
function removePackageFromVehicle(plate, quantity)
	local index, vehicle = getDatabaseVehicleFromPlate(plate)
	local totalOfPackages = vehicle.packages - quantity
	if totalOfPackages < 0 then
		return false
	else
		setPackagesOfVehicleFromIndex(index, totalOfPackages)
		return true
	end
end

-- On modifie le nombre de packets d'un véhicule dans le cache
function setPackagesOfVehicleFromIndex(index, packages)
    if serverTruckDatabase[index] then
        serverTruckDatabase[index].packages = packages
    end
end

-- On recupère le nombre de packets d'un véhicule
function getPackagesOnVehicle(plate)
	return getDatabaseIndexFromPlate(plate).packages
end

function generateDeliveryDestination()
	return deliveryDestinations[ math.random( #deliveryDestinations ) ]
end

function getDeliveryDestinationForVehicle(plate)
end

-- On recupère le véhicule depuis le cache
function getDatabaseVehicleFromPlate(plate)
    while true do
        for index, vehicle in pairs(serverTruckDatabase) do
            if vehicle.plate == plate then
                return index, vehicle
            end
        end
        table.insert(serverTruckDatabase, { plate = plate, packages = 0, destination = nil})
        Citizen.Wait(100)
    end
end
