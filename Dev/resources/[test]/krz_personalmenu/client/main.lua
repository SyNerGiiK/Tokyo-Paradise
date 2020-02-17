ESX = nil

_menuPool = nil
local personalmenu = {}

local invItem, wepItem, billItem, mainMenu, itemMenu, weaponItemMenu = {}, {}, {}, nil, nil, nil

local isDead, inAnim = false, false

local noclip, godmode, visible, gamerTags = false, false, false, {}

local actualGPS, actualGPSIndex = _U('default_gps'), 1
local actualVoice, actualVoiceIndex = _U('default_voice'), 2

local societymoney, societymoney2 = nil, nil

local wepList = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end


	ESX.UI.HUD.RemoveElement('esx_voice')
	local htmlElement = '<div style="{{style}}"><img src="https://www.monaco-rp.com/fivem/hud/icon_speaker_{{image}}.png">{{text}}</div>'
	ESX.UI.HUD.RegisterElement('esx_voice', 12, 0, htmlElement, {
		style = nil,
		image = 'mute',
		text = 'Normal'
	})

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin) actualSkin = skin end)
		Citizen.Wait(10)
	end

	wepList = ESX.GetWeaponList()

	_menuPool = NativeUI.CreatePool()

	mainMenu = NativeUI.CreateMenu(Config.servername, _U('mainmenu_subtitle'))
	itemMenu = NativeUI.CreateMenu(Config.servername, _U('inventory_actions_subtitle'))
	weaponItemMenu = NativeUI.CreateMenu(Config.servername, _U('loadout_actions_subtitle'))
	_menuPool:Add(mainMenu)
	_menuPool:Add(itemMenu)
	_menuPool:Add(weaponItemMenu)
end)

Citizen.CreateThread(function()
	local fixingVoice = true

	NetworkSetTalkerProximity(0.1)

	while true do
		NetworkSetTalkerProximity(8.0)
		if not fixingVoice then
			break
		end
		Citizen.Wait(10)
	end

	SetTimeout(10000, function()
		fixingVoice = false
	end)
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	_menuPool:CloseAllMenus()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

-- Weapon Menu --
RegisterNetEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedC')
AddEventHandler('KorioZ-PersonalMenu:Weapon_addAmmoToPedC', function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

-- Admin Menu --
RegisterNetEvent('KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('KorioZ-PersonalMenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput('KORIOZ_BOX_XYZ', _U('dialogbox_xyz'), '', 50)

	if pos ~= nil and pos ~= '' then
		local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')
				
		if x ~= nil and y ~= nil and z ~= nil then
			SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
		end
	end
end

-- NOCLIP 
function admin_no_clip()
	noclip = not noclip

	if noclip then
		FreezeEntityPosition(plyPed, true)
		SetEntityInvincible(plyPed, true)
		SetEntityCollision(plyPed, false, false)

		SetEntityVisible(plyPed, false, false)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification(_U('admin_noclipon'))
	else
		FreezeEntityPosition(plyPed, false)
		SetEntityInvincible(plyPed, false)
		SetEntityCollision(plyPed, true, true)

		SetEntityVisible(plyPed, true, false)

		SetEveryoneIgnorePlayer(PlayerId(), false)
		SetPoliceIgnorePlayer(PlayerId(), false)
		ESX.ShowNotification(_U('admin_noclipoff'))
	end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

-- GOD MODE
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification(_U('admin_godmodeon'))
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification(_U('admin_godmodeoff'))
	end
end

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_ghoston'))
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_ghostoff'))
	end
end

-- Réparer vehicule
function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput('KORIOZ_BOX_VEHICLE_NAME', _U('dialogbox_vehiclespawner'), '', 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)

		if type(vehicleName) == 'string' then
			ESX.Game.SpawnVehicle(vehicleName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
				TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
			end)
		end
	end
end

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords, 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)
	ESX.ShowNotification(_U('admin_vehicleflip'))
end

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
		end
	end
end

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
		end
	end
end

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amount)
		end
	end
end

-- Afficher Coord
function modo_showcoord()
	showcoord = not showcoord
end

-- Afficher Nom
function modo_showname()
	showname = not showname
end

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		ESX.ShowNotification(_U('admin_tpmarker'))
	else
		ESX.ShowNotification(_U('admin_nomarker'))
	end
end

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('secureesx_ambulancejob:revive', plyId)
		end
	end
end

function changer_skin()
	_menuPool:CloseAllMenus()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

function startAttitude(lib, anim)
	Citizen.CreateThread(function()
		RequestAnimSet(anim)

		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(0)
		end

		SetPedMotionBlur(plyPed, false)
		SetPedMovementClipset(plyPed, anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(plyPed, anim, 0, false)
end

function AddMenuInventoryMenu(menu, playerInfos)
	inventorymenu = _menuPool:AddSubMenu(menu, _U('inventory_title'))

	-- Items de l'inventaire du joueur
	for i = 1, #playerInfos.inventory, 1 do
		local count = playerInfos.inventory[i].count
		
		if count > 0 then
			local label = playerInfos.inventory[i].label
			local value = playerInfos.inventory[i].name
			local defaultSelection = 1
			local options = { _U('inventory_give_button'), _U('inventory_drop_button') }
			if playerInfos.inventory[i].usable then
				table.insert(options, _U('inventory_use_button'))
				defaultSelection = 3
			end

			table.insert(invItem, value)

			invItem[value] = NativeUI.CreateListItem(label .. ' (' .. count .. ')', options, defaultSelection)
			inventorymenu.SubMenu:AddItem(invItem[value])
		end
	end

	for i = 1, #wepList, 1 do
		local weaponHash = GetHashKey(wepList[i].name)

		if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
			local options = { _U('inventory_give_button'), _U('inventory_drop_button') }
			local ammo = GetAmmoInPedWeapon(plyPed, weaponHash)
			local label = wepList[i].label .. ' [' .. ammo .. ']'
			local value = wepList[i].name

			table.insert(wepItem, value)
			wepItem[value] = NativeUI.CreateListItem(label, options, 1)
			inventorymenu.SubMenu:AddItem(wepItem[value])
		end
	end

	inventorymenu.SubMenu.OnListSelect = function(sender, item, index)
	-- _menuPool:CloseAllMenus(true)
	-- itemMenu:Visible(true)
	-- TODO: DUPLICATION OBJET PAS CONSOMME
		--print(json.encode(item),index)
		for i = 1, #playerInfos.inventory, 1 do
			local value = playerInfos.inventory[i].name

			if item == invItem[value] then
				local label = playerInfos.inventory[i].label
				local count = playerInfos.inventory[i].count
				local usable = playerInfos.inventory[i].usable
				local canRemove = playerInfos.inventory[i].canRemove
				if index == 1 then -- donner
					local quantity = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_select_amount', count), '', 8)
					_menuPool:CloseAllMenus()
					TriggerEvent("drp_esxbridge:client:playerIdentity:selectClosestPlayer", "Séléctionnez un joueur", 3, function(playerId)
						TriggerServerEvent('secureesx:giveInventoryItem', GetPlayerServerId(playerId), 'item_standard', value, tonumber(quantity))
					end)
				elseif index == 2 then -- jeter
					ESX.ShowNotification('~r~Impossible de jeter des objets pour le moment.')
					--[[if canRemove then
						if not IsPedSittingInAnyVehicle(plyPed) then
							local quantity = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_select_amount', count), '', 8)
							if quantity ~= nil then
								TriggerServerEvent('secureesx:removeInventoryItem', 'item_standard', value, tonumber(quantity))
								_menuPool:CloseAllMenus()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_drop', label))
						end
					else
						ESX.ShowNotification(_U('not_droppable', label))
					end--]]
				elseif index == 3 then -- utiliser
					TriggerServerEvent('esx:useItem', value)
					_menuPool:CloseAllMenus()
				end
			end
		end
		
		for i = 1, #wepList, 1 do
			local weaponHash = GetHashKey(wepList[i].name)

			if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(plyPed, weaponHash)
				local value = wepList[i].name
				local label = wepList[i].label

				if item == wepItem[value] then
					if index == 1 then -- donner
						_menuPool:CloseAllMenus()
						TriggerEvent("drp_esxbridge:client:playerIdentity:selectClosestPlayer", "Séléctionnez un joueur", 3, function(playerId)
							TriggerServerEvent('secureesx:giveInventoryItem', GetPlayerServerId(playerId), 'item_weapon', value, ammo)
							
						end)
					elseif index == 2 then -- jeter
						ESX.ShowNotification('~r~Impossible de jeter des objets pour le moment.')
						--[[if not IsPedSittingInAnyVehicle(plyPed) then
							TriggerServerEvent('secureesx:removeInventoryItem', 'item_weapon', value)
							_menuPool:CloseAllMenus()
						else
							ESX.ShowNotification(_U('in_vehicle_drop', label))
						end]]--
					end
				end
			end
		end
	end
end

function AddMenuWalletMenu(menu, playerInfos)
	personalmenu.moneyOption = { _U('wallet_option_give'), _U('wallet_option_drop') }
	personalmenu.cardOption = { _U('wallet_option_look'), _U('wallet_option_show') }

	walletmenu = _menuPool:AddSubMenu(menu, _U('wallet_title'))

	local walletJob = NativeUI.CreateItem(_U('wallet_job_button', playerInfos.job.label, playerInfos.job.grade_label), '')
	walletmenu.SubMenu:AddItem(walletJob)

	local walletMoney = nil
	if playerInfos.money > 0 then
		walletMoney = NativeUI.CreateListItem(_U('wallet_money_button', ESX.Math.GroupDigits(playerInfos.money)), personalmenu.moneyOption, 1)
	else
		walletMoney = NativeUI.CreateItem(_U('wallet_money_button', ESX.Math.GroupDigits(playerInfos.money)), '')
	end

	walletmenu.SubMenu:AddItem(walletMoney)
	
	local walletbankMoney = nil
	local walletdirtyMoney = nil
	local accounts = playerInfos.accounts
	print(json.encode(accounts))
	for i = 1, #accounts, 1 do
		if accounts[i].name == 'bank' then
			walletbankMoney = NativeUI.CreateItem(_U('wallet_bankmoney_button', ESX.Math.GroupDigits(accounts[i].money)), '')
			walletmenu.SubMenu:AddItem(walletbankMoney)
		end

		if accounts[i].name == 'black_money' then
			if accounts[i].money > 0 then
				walletdirtyMoney = NativeUI.CreateListItem(_U('wallet_blackmoney_button', ESX.Math.GroupDigits(accounts[i].money)), personalmenu.moneyOption, 1)
				walletmenu.SubMenu:AddItem(walletdirtyMoney)
			end
		end
	end

	local idCardID = nil
	local driverCardID = nil
	local fireArmsCardID = nil

	if Config.EnableJsfourIDCard then
		idCardID = NativeUI.CreateListItem(_U('wallet_idcard_button', ''), personalmenu.cardOption, 0)
		walletmenu.SubMenu:AddItem(idCardID)

		driverCardID = NativeUI.CreateListItem(_U('wallet_driver_button', ''), personalmenu.cardOption, 0)
		walletmenu.SubMenu:AddItem(driverCardID)

		fireArmsCardID = NativeUI.CreateListItem(_U('wallet_firearms_button', ''), personalmenu.cardOption, 0)
		walletmenu.SubMenu:AddItem(fireArmsCardID)

	end

	walletmenu.SubMenu.OnListSelect = function(sender, item, index)
		if item == idCardID or item == driverCardID or item == fireArmsCardID then
			if index == 1 then -- regarder
				if item == idCardID then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
				elseif item == driverCardID then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
				elseif item == fireArmsCardID then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
				end
			elseif index == 2 then -- montrer
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					if item == idCardID then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
					elseif item == driverCardID then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'driver')
					elseif item == fireArmsCardID then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'weapon')
					end
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			end
		else
			if index == 1 then
				local quantity = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)
	
				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)
	
					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)
	
						if quantity <= 0 then
							post = false
						end
					end
	
					if post == true then
						_menuPool:CloseAllMenus()
						TriggerEvent("drp_esxbridge:client:playerIdentity:selectClosestPlayer", "Séléctionnez un joueur", 3, function(playerId)
							if item == walletMoney then
								print("success to #".. GetPlayerServerId(playerId) .. " amount: " .. quantity)
								TriggerServerEvent('secureesx:giveInventoryItem', GetPlayerServerId(playerId), 'item_money', 'money', quantity)
								_menuPool:CloseAllMenus()
							elseif item == walletdirtyMoney then
								TriggerServerEvent('secureesx:giveInventoryItem', GetPlayerServerId(playerId), 'item_account', 'black_money', quantity)
								_menuPool:CloseAllMenus()
							end
						end)
					else
						ESX.ShowNotification(_U('amount_invalid'))
					end
				end
			elseif index == 2 then
				ESX.ShowNotification('~r~Impossible de jeter des objets pour le moment.')
				--[[local quantity = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)
	
				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)
	
					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)
	
						if quantity <= 0 then
							post = false
						end
					end
	
					if not IsPedSittingInAnyVehicle(plyPed) then
						if post == true then
							if item == walletMoney then
								TriggerServerEvent('secureesx:removeInventoryItem', 'item_money', 'money', quantity)
								_menuPool:CloseAllMenus()
							elseif item == walletdirtyMoney then
								TriggerServerEvent('secureesx:removeInventoryItem', 'item_account', 'black_money', quantity)
								_menuPool:CloseAllMenus()
							end
						else
							ESX.ShowNotification(_U('amount_invalid'))
						end
					else
						if item == walletMoney then
							ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
						elseif item == walletdirtyMoney then
							ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent sale'))
						end
					end
				end]]--
			end
		end
	end
end

function AddMenuFacturesMenu(menu, playerInfos)
	billMenu = _menuPool:AddSubMenu(menu, _U('bills_title'))
	billItem = {}
	bills = playerInfos.bills
	for i = 1, #bills, 1 do
		local label = bills[i].label
		local amount = bills[i].amount
		local value = bills[i].id

		table.insert(billItem, value)

		billItem[value] = NativeUI.CreateItem(label, '')
		billItem[value]:RightLabel(ESX.Math.GroupDigits(amount).. " €")
		billMenu.SubMenu:AddItem(billItem[value])
	end

	billMenu.SubMenu.OnItemSelect = function(sender, item, index)
		for i = 1, #bills, 1 do
			local label  = bills[i].label
			local value = bills[i].id

			if item == billItem[value] then
				ESX.TriggerServerCallback('esx_billing:payBill', function()
					_menuPool:CloseAllMenus()
				end, value)
			end
		end
	end
end

function AddMenuClothesMenu(menu)
	clothesMenu = _menuPool:AddSubMenu(menu, _U('clothes_title'))

	local torsoItem = NativeUI.CreateItem(_U('clothes_top'), '')
	clothesMenu.SubMenu:AddItem(torsoItem)
	local pantsItem = NativeUI.CreateItem(_U('clothes_pants'), '')
	clothesMenu.SubMenu:AddItem(pantsItem)
	local shoesItem = NativeUI.CreateItem(_U('clothes_shoes'), '')
	clothesMenu.SubMenu:AddItem(shoesItem)
	local bagItem = NativeUI.CreateItem(_U('clothes_bag'), '')
	clothesMenu.SubMenu:AddItem(bagItem)
	local bproofItem = NativeUI.CreateItem(_U('clothes_bproof'), '')
	clothesMenu.SubMenu:AddItem(bproofItem)

	clothesMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == torsoItem then
			setUniform('torso', plyPed)
		elseif item == pantsItem then
			setUniform('pants', plyPed)
		elseif item == shoesItem then
			setUniform('shoes', plyPed)
		elseif item == bagItem then
			setUniform('bag', plyPed)
		elseif item == bproofItem then
			setUniform('bproof', plyPed)
		end
	end
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				handsup, pointing = false, false
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				handsup, pointing = false, false
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function AddMenuAccessoryMenu(menu)
	accessoryMenu = _menuPool:AddSubMenu(menu, _U('accessories_title'))

	local earsItem = NativeUI.CreateItem(_U('accessories_ears'), '')
	accessoryMenu.SubMenu:AddItem(earsItem)
	local glassesItem = NativeUI.CreateItem(_U('accessories_glasses'), '')
	accessoryMenu.SubMenu:AddItem(glassesItem)
	local helmetItem = NativeUI.CreateItem(_U('accessories_helmet'), '')
	accessoryMenu.SubMenu:AddItem(helmetItem)
	local maskItem = NativeUI.CreateItem(_U('accessories_mask'), '')
	accessoryMenu.SubMenu:AddItem(maskItem)

	accessoryMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == earsItem then
			SetUnsetAccessory('Ears')
		elseif item == glassesItem then
			SetUnsetAccessory('Glasses')
		elseif item == helmetItem then
			SetUnsetAccessory('Helmet')
		elseif item == maskItem then
			SetUnsetAccessory('Mask')
		end
	end
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
				elseif _accessory == 'glasses' then
					mAccessory = 0
					startAnimAction('clothingspecs', 'try_glasses_positive_a')
					Citizen.Wait(1000)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(1000)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'mask' then
					mAccessory = 0
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(850)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			if _accessory == 'ears' then
				ESX.ShowNotification(_U('accessories_no_ears'))
			elseif _accessory == 'glasses' then
				ESX.ShowNotification(_U('accessories_no_glasses'))
			elseif _accessory == 'helmet' then
				ESX.ShowNotification(_U('accessories_no_helmet'))
			elseif _accessory == 'mask' then
				ESX.ShowNotification(_U('accessories_no_mask'))
			end
		end
	end, accessory)
end

function AddMenuAnimationMenu(menu)

	
	local animationItem = NativeUI.CreateItem(_U('animation_title'), '')
	menu:AddItem(animationItem)
	
	menu.OnItemSelect = function(sender, item, index)
		if item == animationItem then
			_menuPool:CloseAllMenus()
			TriggerEvent('dpemotes:openMenu')
		end
	end
end


function AddMenuVehicleMenu(menu)
	personalmenu.frontLeftDoorOpen = false
	personalmenu.frontRightDoorOpen = false
	personalmenu.backLeftDoorOpen = false
	personalmenu.backRightDoorOpen = false
	personalmenu.hoodDoorOpen = false
	personalmenu.trunkDoorOpen = false
	personalmenu.doorList = {
		_U('vehicle_door_frontleft'),
		_U('vehicle_door_frontright'),
		_U('vehicle_door_backleft'),
		_U('vehicle_door_backright')
	}

	vehicleMenu = _menuPool:AddSubMenu(menu, _U('vehicle_title'))

	local vehEngineItem = NativeUI.CreateItem(_U('vehicle_engine_button'), '')
	vehicleMenu.SubMenu:AddItem(vehEngineItem)
	local vehDoorListItem = NativeUI.CreateListItem(_U('vehicle_door_button'), personalmenu.doorList, 1)
	vehicleMenu.SubMenu:AddItem(vehDoorListItem)
	local vehHoodItem = NativeUI.CreateItem(_U('vehicle_hood_button'), '')
	vehicleMenu.SubMenu:AddItem(vehHoodItem)
	local vehTrunkItem = NativeUI.CreateItem(_U('vehicle_trunk_button'), '')
	vehicleMenu.SubMenu:AddItem(vehTrunkItem)

	vehicleMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehEngineItem then
				if GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, false, false, true)
					SetVehicleUndriveable(plyVehicle, true)
				elseif not GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, true, false, true)
					SetVehicleUndriveable(plyVehicle, false)
				end
			elseif item == vehHoodItem then
				if not personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 4, false, false)
				elseif personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 4, false, false)
				end
			elseif item == vehTrunkItem then
				if not personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 5, false, false)
				elseif personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 5, false, false)
				end
			end
		end
	end

	vehicleMenu.SubMenu.OnListSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehDoorListItem then
				if index == 1 then
					if not personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 0, false, false)
					elseif personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 0, false, false)
					end
				elseif index == 2 then
					if not personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 1, false, false)
					elseif personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 1, false, false)
					end
				elseif index == 3 then
					if not personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 2, false, false)
					elseif personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 2, false, false)
					end
				elseif index == 4 then
					if not personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 3, false, false)
					elseif personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 3, false, false)
					end
				end
			end
		end
	end
end

function AddMenuVoixGPS(menu)
	personalmenu.gps = {
		'Aucun',
		'Poste de Police',
		'Garage Central',
		'Hôpital',
		'Concessionnaire',
		'Benny\'s Custom',
		'Pôle Emploie',
		'Auto école',
		'Téquila-la'
	}

	personalmenu.nivVoix = {
		_U('voice_whisper'),
		_U('voice_normal'),
		_U('voice_cry')
	}

	local gpsItem = NativeUI.CreateListItem(_U('mainmenu_gps_button'), personalmenu.gps, actualGPSIndex)
	menu:AddItem(gpsItem)
	local voixItem = NativeUI.CreateListItem(_U('mainmenu_voice_button'), personalmenu.nivVoix, actualVoiceIndex)
	menu:AddItem(voixItem)

	menu.OnListSelect = function(sender, item, index)
		if item == gpsItem then
			actualGPS = item:IndexToItem(index)
			actualGPSIndex = index

			ESX.ShowNotification(_U('gps', actualGPS))

			if actualGPS == 'Aucun' then
				local plyCoords = GetEntityCoords(plyPed)
				SetNewWaypoint(plyCoords.x, plyCoords.y)
			elseif actualGPS == 'Poste de Police' then
				SetNewWaypoint(425.13, -979.55)
			elseif actualGPS == 'Hôpital' then
				SetNewWaypoint(-449.67, -340.83)
			elseif actualGPS == 'Concessionnaire' then
				SetNewWaypoint(-33.88, -1102.37)
			elseif actualGPS == 'Garage Central' then
				SetNewWaypoint(215.06, -791.56)
			elseif actualGPS == 'Benny\'s Custom' then
				SetNewWaypoint(-212.13, -1325.27)
			elseif actualGPS == 'Pôle Emploie' then
				SetNewWaypoint(-264.83, -964.54)
			elseif actualGPS == 'Auto école' then
				SetNewWaypoint(-829.22, -696.99)
			elseif actualGPS == 'Téquila-la' then
				SetNewWaypoint(-565.09, 273.45)
			elseif actualGPS == 'Bahama Mamas' then
				SetNewWaypoint(-1391.06, -590.34)
			end
		elseif item == voixItem then
			actualVoice = item:IndexToItem(index)
			actualVoiceIndex = index

			ESX.ShowNotification(_U('voice', actualVoice))

			if index == 1 then
				NetworkSetTalkerProximity(1.0)
			elseif index == 2 then
				NetworkSetTalkerProximity(8.0)
			elseif index == 3 then
				NetworkSetTalkerProximity(14.0)
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local voiceLevel = ""
		local voiceIcon = ""
		if actualVoiceIndex == 1 then
			voiceLevel = "Chuchoter"
			voiceIcon = "whisper"
		elseif actualVoiceIndex == 2 then
			voiceLevel = "Normal"
			voiceIcon = "normal"
		elseif actualVoiceIndex == 3 then
			voiceLevel = "Crier"
			voiceIcon = "shout"
		end
		if NetworkIsPlayerTalking(PlayerId()) then
			ESX.UI.HUD.UpdateElement('esx_voice', {	style = 'color: #00dfcd', text = voiceLevel, image = voiceIcon})
		elseif not NetworkIsPlayerTalking(PlayerId()) then
			ESX.UI.HUD.UpdateElement('esx_voice', {	style = nil, text = voiceLevel, image = 'off' })
		end
	end
end)

function AddMenuAdminMenu(menu, playerGroup)
	adminMenu = _menuPool:AddSubMenu(menu, _U('admin_title'))

	if playerGroup == 'mod' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			end
		end
	elseif playerGroup == 'admin' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), '')
		adminMenu.SubMenu:AddItem(noclipItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), '')
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), '')
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), '')
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), '')
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	elseif playerGroup == 'superadmin' or playerGroup == 'owner' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local tptoXYZItem = NativeUI.CreateItem(_U('admin_tpxyz_button'), '')
		adminMenu.SubMenu:AddItem(tptoXYZItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), '')
		adminMenu.SubMenu:AddItem(noclipItem)
		local godmodeItem = NativeUI.CreateItem(_U('admin_godmode_button'), '')
		adminMenu.SubMenu:AddItem(godmodeItem)
		local ghostmodeItem = NativeUI.CreateItem(_U('admin_ghostmode_button'), '')
		adminMenu.SubMenu:AddItem(ghostmodeItem)
		local spawnVehItem = NativeUI.CreateItem(_U('admin_spawnveh_button'), '')
		adminMenu.SubMenu:AddItem(spawnVehItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), '')
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), '')
		adminMenu.SubMenu:AddItem(returnVehItem)
		local givecashItem = NativeUI.CreateItem(_U('admin_givemoney_button'), '')
		adminMenu.SubMenu:AddItem(givecashItem)
		local givebankItem = NativeUI.CreateItem(_U('admin_givebank_button'), '')
		adminMenu.SubMenu:AddItem(givebankItem)
		local givedirtyItem = NativeUI.CreateItem(_U('admin_givedirtymoney_button'), '')
		adminMenu.SubMenu:AddItem(givedirtyItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), '')
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), '')
		adminMenu.SubMenu:AddItem(revivePlrItem)
		local skinPlrItem = NativeUI.CreateItem(_U('admin_changeskin_button'), '')
		adminMenu.SubMenu:AddItem(skinPlrItem)
		local saveSkinPlrItem = NativeUI.CreateItem(_U('admin_saveskin_button'), '')
		adminMenu.SubMenu:AddItem(saveSkinPlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == tptoXYZItem then
				admin_tp_pos()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == godmodeItem then
				admin_godmode()
			elseif item == ghostmodeItem then
				admin_mode_fantome()
			elseif item == spawnVehItem then
				admin_vehicle_spawn()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == givecashItem then
				admin_give_money()
				_menuPool:CloseAllMenus()
			elseif item == givebankItem then
				admin_give_bank()
				_menuPool:CloseAllMenus()
			elseif item == givedirtyItem then
				admin_give_dirty()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			elseif item == skinPlrItem then
				changer_skin()
			elseif item == saveSkinPlrItem then
				save_skin()
			end
		end
	end
end

function GeneratePersonalMenu(playerInfos)
	AddMenuInventoryMenu(mainMenu, playerInfos)
	AddMenuWalletMenu(mainMenu, playerInfos)
	AddMenuClothesMenu(mainMenu)
	AddMenuAccessoryMenu(mainMenu)
	AddMenuAnimationMenu(mainMenu)

	if IsPedSittingInAnyVehicle(plyPed) then
		if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
			AddMenuVehicleMenu(mainMenu)
		end
	end


	AddMenuFacturesMenu(mainMenu, playerInfos)
	AddMenuVoixGPS(mainMenu)

	local playerGroup = playerInfos.playerGroup
	if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
		AddMenuAdminMenu(mainMenu, playerGroup)
	end

	_menuPool:RefreshIndex()
end

Citizen.CreateThread(function()
	while true do
		if IsControlJustReleased(0, Config.Menu.clavier) and IsInputDisabled(1) and not isDead then
			if mainMenu ~= nil and not mainMenu:Visible() then
				ESX.TriggerServerCallback('krz:GetUsersInfoForMenu', function(playerInfos)
					GeneratePersonalMenu(playerInfos)
					mainMenu:Visible(true)
					Citizen.Wait(10)
				end)
			end
		elseif IsControlJustReleased(0, 172) and not IsInputDisabled(1) and not isDead then
			if mainMenu ~= nil and not mainMenu:Visible() then
				ESX.TriggerServerCallback('krz:GetUsersInfoForMenu', function(playerInfos)
					GeneratePersonalMenu(playerInfos)
					mainMenu:Visible(true)
					Citizen.Wait(10)
				end)
			end
		end
		Citizen.Wait(0)
	end
end)
Citizen.CreateThread(function()
	while true do
		if _menuPool ~= nil then
			_menuPool:ProcessMenus()
		end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while _menuPool ~= nil and _menuPool:IsAnyMenuOpen() do
			Citizen.Wait(0)

			if not _menuPool:IsAnyMenuOpen() then
				mainMenu:Clear()
				itemMenu:Clear()
				weaponItemMenu:Clear()

				_menuPool:Clear()
				_menuPool:Remove()

				personalmenu = {}

				invItem = {}
				wepItem = {}
				billItem = {}

				collectgarbage()

				_menuPool = NativeUI.CreatePool()

				mainMenu = NativeUI.CreateMenu(Config.servername, _U('mainmenu_subtitle'))
				itemMenu = NativeUI.CreateMenu(Config.servername, _U('inventory_actions_subtitle'))
				weaponItemMenu = NativeUI.CreateMenu(Config.servername, _U('loadout_actions_subtitle'))
				_menuPool:Add(mainMenu)
				_menuPool:Add(itemMenu)
				_menuPool:Add(weaponItemMenu)
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()
		
		if IsControlJustReleased(0, Config.stopAnim.clavier) and GetLastInputMethod(2) and not isDead then
			handsup, pointing = false, false
			ClearPedTasks(plyPed)
		end

		if IsControlPressed(1, Config.TPMarker.clavier1) and IsControlJustReleased(1, Config.TPMarker.clavier2) and GetLastInputMethod(2) and not isDead then
			ESX.TriggerServerCallback('krz:GetUsersInfoForMenu', function(playerInfos)
				local playerGroup = playerInfos.playerGroup
				if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
					admin_tp_marker()
				end
			end)
		end

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			Text('~r~X~s~: ' .. playerPos.x .. ' ~b~Y~s~: ' .. playerPos.y .. ' ~g~Z~s~: ' .. playerPos.z .. ' ~y~Angle~s~: ' .. GetEntityHeading(plyPed))
		end

		if noclip then
			local coords = GetEntityCoords(plyPed)
			local camCoords = getCamDirection()

			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				coords = coords + (Config.noclip_speed * camCoords)
			end

			if IsControlPressed(0, 269) then
				coords = coords - (Config.noclip_speed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, coords, true, true, true)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if showname then
			print('displayname')
			for k, v in ipairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
				if otherPed ~= plyPed then
					if GetDistanceBetweenCoords(GetEntityCoords(plyPed), GetEntityCoords(otherPed)) < 800.0 then
						if gamerTags[v] == nil then
							TriggerEvent("drp_esxbridge:client:playerIdentity:get", v, function(name)
								local playerName = nil
								if name ~= nil then
									playerName = ('%s %s [%s]'):format(name.firstName, name.lastName, GetPlayerServerId(v), name.hasVisa)
								else
									playerName = ('Nom introuvable [%s]'):format(GetPlayerServerId(v))
								end
								gamerTags[v] = CreateFakeMpGamerTag(otherPed, playerName, false, false, '', 0)
								if name.hasVisa ~= 1 then
									SetMpGamerTagColour(gamerTags[v], 0, 125)
								end
							end)
						end
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
			Citizen.Wait(500)
		else
			for k, v in ipairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
				gamerTags[v] = nil
			end
			Citizen.Wait(1000)
		end
	end
end)

RegisterCommand('test123', function()

	local trackedEntities = {
		'v_ilev_fb_doorshortr',
		'v_ilev_fb_doorshortl',
		'v_ilev_cor_doorglassa',
		'v_ilev_cor_doorglassb',
		'v_ilev_ph_gendoor003'
	}

	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	for i=1, #trackedEntities, 1 do
		local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

		if DoesEntityExist(object) then
			local objCoords = GetEntityCoords(object)
			local distance  = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, objCoords.x, objCoords.y, objCoords.z, true)

			print(trackedEntities[i] .. ' ('..GetHashKey(trackedEntities[i])..') a été trouvé !')
			print(objCoords.x, objCoords.y, objCoords.z, GetEntityHeading(object));
		end
	end
end, false)