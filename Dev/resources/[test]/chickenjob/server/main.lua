local maxZywych = 15 -- ile mozna miec max zywych kurczkaow w EQ
local MaxMartweKurczaki = 30 -- ile mozna miec martwych kurczakow w EQ
local MaxZapakowanychKurczakow = 30 -- ile mozna miec w EQ zapakowanych kurczakow
local packagePrice = 20 -- ilosc hajsu za 2 paczki kurczaka

-----------------------------
---nizej lepiej nie ruszaj---
-----------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('tost:wkladajKurczki')
AddEventHandler('tost:wkladajKurczki', function(totalOfchickens)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local alive_chicken = xPlayer.getInventoryItem('alive_chicken')

    if alive_chicken.count + totalOfchickens <= alive_chicken.limit then
        xPlayer.addInventoryItem('alive_chicken', totalOfchickens)
        Wait(1500)
    else
        TriggerClientEvent('esx:showNotification', source, _U('error_too_much_alive_chicken', alive_chicken.limit))
        Wait(2500)
    end
end)

RegisterServerEvent('tostKurczaki:przerob')
AddEventHandler('tostKurczaki:przerob', function(option)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local alive_chicken = xPlayer.getInventoryItem('alive_chicken')
    local slaughtered_chicken = xPlayer.getInventoryItem('slaughtered_chicken')
    local packaged_chicken = xPlayer.getInventoryItem('packaged_chicken')

    if option == 1 then
        if alive_chicken.count > 0 and slaughtered_chicken.count + 2 <= slaughtered_chicken.limit then
            
            xPlayer.removeInventoryItem('alive_chicken', 1)
            xPlayer.addInventoryItem('slaughtered_chicken', 2)
            Wait(1500)
        else
            TriggerClientEvent('esx:showNotification', source, _U('error_too_much_slaughtered_chicken', slaughtered_chicken.limit))
            Wait(2500)
        end
    end

    if option == 2 then
        if slaughtered_chicken.count > 1 and packaged_chicken.count + 2 <= slaughtered_chicken.limit then
            xPlayer.removeInventoryItem('slaughtered_chicken', 2)
            xPlayer.addInventoryItem('packaged_chicken', 2)
            Wait(1500)
        else
            TriggerClientEvent('esx:showNotification', source, _U('error_too_much_packaged_chicken', packaged_chicken.limit))
            Wait(2500)
        end
    end
    
    if option == 3 then
        if packaged_chicken.count > 0 then
            xPlayer.removeInventoryItem('packaged_chicken', 2)
            xPlayer.addMoney(packagePrice)
            TriggerEvent('drp_esxbridge:server:addSalaryFromNpcRun', GetPlayerIdentifier(source), packagePrice, 10)
            TriggerClientEvent('esx:showNotification', source, _U('package_resell_success', packagePrice))
            Wait(1500)
        end
    end

end)
