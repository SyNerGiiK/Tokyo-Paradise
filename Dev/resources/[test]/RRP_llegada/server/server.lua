ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DelayToStartNewFly = 0

local WaitingList = {}

RegisterServerEvent('startfly:register')
AddEventHandler('startfly:register', function()
    table.insert(WaitingList, source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.showNotification("Tu es dans la fille d'attente, position "..#WaitingList.."/"..#WaitingList)
end)

Citizen.CreateThread(function()
    while true do
        if DelayToStartNewFly == 0 then
            if #WaitingList > 0 then
                -- Start Fly for players
                TriggerClientEvent("RRP_llegada:inicio", WaitingList[1])
                WaitingList[1] = nil
                DelayToStartNewFly = 45
            else -- Personne en fille d'attente, on laisse le delais à 0
                DelayToStartNewFly = 0
            end
        else
            DelayToStartNewFly = DelayToStartNewFly -1
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if #WaitingList > 0 then
            for i = 1, #WaitingList do
                local xPlayer = ESX.GetPlayerFromId(WaitingList[i])
                xPlayer.showNotification("Tu es dans la fille d'attente, position "..i.."/"..#WaitingList)
            end
        end
        Citizen.Wait(4000)
    end
end)
