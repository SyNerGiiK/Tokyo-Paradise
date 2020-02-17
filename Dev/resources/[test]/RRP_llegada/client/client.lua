ESX = nil

local disablecontrols = false
local AirPlane
local pilot, copilot
local passenger1, passenger2, passenger3, passenger4, passenger5, passenger6
local isInCruise, CruiseSpeed = false, 50.01

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("RRP_llegada:inicio")
AddEventHandler("RRP_llegada:inicio", function()  
	disablecontrols = true
	DoScreenFadeOut(800)
	local modelHash = GetHashKey('nimbus')
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do 	Citizen.Wait(10) end

	AirPlane = CreateVehicle(modelHash, 1288.873, 5212.842, 528.960, 135.00, true, false)
	local a_m_y_business_02 = GetHashKey('a_m_y_business_02')
	local mp_m_boatstaff_01 = GetHashKey('mp_m_boatstaff_01')
	local mp_f_boatstaff_01 = GetHashKey('mp_f_boatstaff_01')
	local a_f_o_ktown_01 = GetHashKey('a_f_o_ktown_01')
	local a_m_m_genfat_01 = GetHashKey('a_m_m_genfat_01')
	local u_m_y_chip = GetHashKey('u_m_y_chip')

	RequestModel(a_m_y_business_02)
	RequestModel(mp_m_boatstaff_01)
	RequestModel(mp_f_boatstaff_01)
	RequestModel(a_f_o_ktown_01)
	RequestModel(a_m_m_genfat_01)
	RequestModel(u_m_y_chip)
	
	while not HasModelLoaded(a_m_y_business_02) do  Citizen.Wait(10) end
	while not HasModelLoaded(mp_m_boatstaff_01) do  Citizen.Wait(10) end
	while not HasModelLoaded(mp_f_boatstaff_01) do  Citizen.Wait(10) end
	while not HasModelLoaded(a_f_o_ktown_01) do	    Citizen.Wait(10) end
	while not HasModelLoaded(a_m_m_genfat_01) do	Citizen.Wait(10) end
	while not HasModelLoaded(u_m_y_chip) do	        Citizen.Wait(10) end

	pilot      = CreatePedInsideVehicle(AirPlane, 4, mp_m_boatstaff_01, -1, true, true)
	copilot    = CreatePedInsideVehicle(AirPlane, 2, mp_f_boatstaff_01,  0, true, true)
	passenger1 = CreatePedInsideVehicle(AirPlane, 4, a_m_y_business_02,  2, true, true)
	passenger2 = CreatePedInsideVehicle(AirPlane, 2, a_f_o_ktown_01,     3, true, true)
	passenger3 = CreatePedInsideVehicle(AirPlane, 4, a_m_m_genfat_01,    4, true, true)
	passenger4 = CreatePedInsideVehicle(AirPlane, 4, a_m_y_business_02,  5, true, true)
	passenger5 = CreatePedInsideVehicle(AirPlane, 4, u_m_y_chip,         6, true, true)
	passenger6 = CreatePedInsideVehicle(AirPlane, 4, a_m_y_business_02,  7, true, true)

	--NetworkSetEntityInvisibleToNetwork(pilot,		true)
	--NetworkSetEntityInvisibleToNetwork(copilot,		true)
	--NetworkSetEntityInvisibleToNetwork(passenger1,	true)
	--NetworkSetEntityInvisibleToNetwork(passenger2,	true)
	--NetworkSetEntityInvisibleToNetwork(passenger3,	true)
	--NetworkSetEntityInvisibleToNetwork(passenger4,	true)
	--NetworkSetEntityInvisibleToNetwork(passenger5,	true)
	--NetworkSetEntityInvisibleToNetwork(passenger6,	true)

	SetVehicleForwardSpeed(AirPlane, CruiseSpeed)
	isInCruise = true
	TaskPlaneMission(pilot, AirPlane, 0, 0, -2546.383, -2311.280, 163.619, 4, 555.0, 0.0, 197.735, 530.0, 120.0)

	Citizen.Wait(2000)
	SetPedIntoVehicle(PlayerPedId(), AirPlane, 1)
	TriggerEvent('instance:close')
	Citizen.Wait(1000)
	DoScreenFadeIn(2800)
	
	Citizen.Wait(60000)
	SendNUIMessage({action = 'flyrecord'})
end)

Citizen.CreateThread(function()
	while true do  
	    Citizen.Wait(0)
		
		if disablecontrols == true then
		    DisableControlAction(0, 37, true)
		    DisableControlAction(0, 288, true)
		    DisableControlAction(0, 289, true)
		    DisableControlAction(0, 170, true)
		    DisableControlAction(0, 166, true)
		    DisableControlAction(0, 167, true)
		    DisableControlAction(0, 168, true)
		    DisableControlAction(0, 56, true)
		    DisableControlAction(0, 57, true)
		    DisableControlAction(0, 245, true)
		    DisableControlAction(0, 23, true)
		    DisableControlAction(0, 32, true) 
		    DisableControlAction(0, 8, true)
		    DisableControlAction(0, 34, true)  
		    DisableControlAction(0, 9, true)
		    DisableControlAction(0, 311, true)
		    DisableControlAction(0, 246, true)
			DisableControlAction(0, 182, true)
		    DisableControlAction(0, 75, true)
		    DisableControlAction(0, 344, true)
        end
	end
end)
Citizen.CreateThread(function()
	while true do
		if isInCruise then
			SetVehicleForwardSpeed(AirPlane, CruiseSpeed)
		end
		Citizen.Wait(200)
	end
end)

local landing = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if not landing then
			if IsEntityInAir(AirPlane) then
				SetVehicleLandingGear(AirPlane, 1)
			end
			if IsEntityInZone(AirPlane, "RICHM") or IsEntityInZone(AirPlane, "OCEANA") then
				TaskPlaneLand(pilot, AirPlane, -1979.979, -2771.635, 12.828, -973.457, -3359.273, 13.944)
				SetPedKeepTask(pilot, true)
				landing = true
				isInCruise = false
			end
		end

		if not IsEntityInAir(AirPlane) and IsPedInVehicle(PlayerPedId(), AirPlane, false) then
			TaskVehicleTempAction(pilot, Airplane, 27, -1)
			SetVehicleHandbrake(AirPlane, true)

			if GetEntitySpeed(AirPlane) < 10.0 then
				if IsEntityInZone(PlayerPedId(), "AIRP") then
					DoScreenFadeOut(200)
					Wait(200)
					while not IsScreenFadedOut() do
						Citizen.Wait(0)
					end
					ESX.Game.Teleport(PlayerPedId(),vector3(-1044.83, -2750.02, 21.36))
					disablecontrols = false
					SetEntityHeading(PlayerPedId(), 340.2285)
					Wait(800)
					DoScreenFadeIn(500)
				end
			end
		end

		if not IsPedInVehicle(PlayerPedId(), AirPlane, false) and landing == true then
			SetVehicleHandbrake(AirPlane, false)
			SetBlockingOfNonTemporaryEvents(pilot, false)
			
			SetEntityAsNoLongerNeeded(pilot)
			SetEntityAsNoLongerNeeded(copilot)
			SetEntityAsNoLongerNeeded(passenger1)
			SetEntityAsNoLongerNeeded(passenger2)
			SetEntityAsNoLongerNeeded(passenger3)
			SetEntityAsNoLongerNeeded(passenger4)
			SetEntityAsNoLongerNeeded(passenger5)
			SetEntityAsNoLongerNeeded(passenger6)
			
			SetEntityAsNoLongerNeeded(AirPlane)
			landing = false
		end

	end
end)