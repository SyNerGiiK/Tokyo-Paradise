local _i, _f, _v, _r, _ri, _rf, _rl, _s, _rv, _ro, _in, _ii, _fi =
	Citizen.PointerValueInt(), Citizen.PointerValueFloat(), Citizen.PointerValueVector(),
	Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger(), Citizen.ResultAsFloat(), Citizen.ResultAsLong(), Citizen.ResultAsString(), Citizen.ResultAsVector(), Citizen.ResultAsObject(),
	Citizen.InvokeNative, Citizen.PointerValueIntInitialized, Citizen.PointerValueFloatInitialized

local g = _G
local rs = rawset
local msgpack = msgpack
local _tostring = tostring
local function _ts(num)
	if num == 0 or not num then -- workaround for users calling string parameters with '0', also nil being translated
		return nil
	end
	return _tostring(num)
end
local function _ch(hash)
	if g.type(hash) == 'string' then
		return g.GetHashKey(hash)
	end

	return hash
end

local function _mfr(fn)
	return g.Citizen.GetFunctionReference(fn)
end

local Global = setmetatable({}, { __newindex = function(_, n, v)
	g[n] = v

	rs(_, n, v)
end})

_ENV = nil

--- Returns whether or not the specified player has enough information to start a commerce session for.
-- @param playerSrc The player handle
-- @return True or false.
function Global.CanPlayerStartCommerceSession(playerSrc)
	return _in(0x429461c3, _ts(playerSrc), _r)
end

--- Cancels the currently executing event.
function Global.CancelEvent()
	return _in(0xfa29d35d)
end

--- thisScriptCheck - can be destroyed if it belongs to the calling script.
-- ```
-- ```
-- NativeDB Added Parameter 8: BOOL p7
function Global.CreateVehicle(modelHash, x, y, z, heading, isNetwork, thisScriptCheck)
	return _in(0xdd75460a, _ch(modelHash), x, y, z, heading, isNetwork, thisScriptCheck, _r, _ri)
end

function Global.DeleteFunctionReference(referenceIdentity)
	return _in(0x1e86f206, _ts(referenceIdentity))
end

function Global.DoesEntityExist(entity)
	return _in(0x3ac90869, entity, _r)
end

--- Requests whether or not the player owns the specified SKU.
-- @param playerSrc The player handle
-- @param skuId The ID of the SKU.
-- @return A boolean.
function Global.DoesPlayerOwnSku(playerSrc, skuId)
	return _in(0x167aba27, _ts(playerSrc), skuId, _r)
end

function Global.DropPlayer(playerSrc, reason)
	return _in(0xba0613e1, _ts(playerSrc), _ts(reason))
end

function Global.DuplicateFunctionReference(referenceIdentity)
	return _in(0xf4e2079d, _ts(referenceIdentity), _r, _s)
end

function Global.EnableEnhancedHostSupport(enabled)
	return _in(0xf97b1c93, enabled)
end

function Global.ExecuteCommand(commandString)
	return _in(0x561c060b, _ts(commandString))
end

function Global.FlagServerAsPrivate(private_)
	return _in(0x13b6855d, private_)
end

--- ```
-- No, this should be called SET_ENTITY_KINEMATIC. It does more than just "freeze" it's position.
-- ^Rockstar Devs named it like that, Now cry about it.
-- ```
-- Freezes or unfreezes an entity preventing its coordinates to change by the player if set to `true`. You can still change the entity position using SET_ENTITY_COORDS.
-- @param entity The entity to freeze/unfreeze.
-- @param toggle Freeze or unfreeze entity.
function Global.FreezeEntityPosition(entity, toggle)
	return _in(0x65c16d57, entity, toggle)
end

--- Returns all vehicle handles known to the server.
-- The data returned adheres to the following layout:
-- ```
-- [127, 42, 13, 37]
-- ```
-- @return An object containing a list of vehicle handles.
function Global.GetAllVehicles()
	return msgpack.unpack(_in(0x332169f5, _r, _ro))
end

--- Returns the current console output buffer.
-- @return The most recent game console output, as a string.
function Global.GetConsoleBuffer()
	return _in(0xe57429fa, _r, _s)
end

function Global.GetConvar(varName, default_)
	return _in(0x6ccd2564, _ts(varName), _ts(default_), _r, _s)
end

function Global.GetConvarInt(varName, default_)
	return _in(0x935c0ab2, _ts(varName), default_, _r, _ri)
end

--- Returns the name of the currently executing resource.
-- @return The name of the resource.
function Global.GetCurrentResourceName()
	return _in(0xe5e9ebbb, _r, _s)
end

--- Gets the current coordinates for a specified entity. This native is used server side when using OneSync. See <a href="#_0x3FEF770D40960D5A" >GET_ENTITY_COORDS</a> for client side.
-- @param entity The entity to get the coordinates from.
-- @return The current entity coordinates.
function Global.GetEntityCoords(entity)
	return _in(0x1647f1cb, entity, _r, _rv)
end

function Global.GetEntityHeading(entity)
	return _in(0x972cc383, entity, _r, _rf)
end

--- Currently it only works with peds.
function Global.GetEntityHealth(entity)
	return _in(0x8e3222b7, entity, _r, _ri)
end

--- Currently it only works with peds.
function Global.GetEntityMaxHealth(entity)
	return _in(0xc7ae6aa1, entity, _r, _ri)
end

function Global.GetEntityModel(entity)
	return _in(0xdafcb3ec, entity, _r, _ri)
end

function Global.GetEntityPopulationType(entity)
	return _in(0xfc30ddff, entity, _r, _ri)
end

function Global.GetEntityRotation(entity)
	return _in(0x8ff45b04, entity, _r, _rv)
end

function Global.GetEntityRotationVelocity(entity)
	return _in(0x9bf8a73f, entity, _r, _rv)
end

function Global.GetEntityScript(entity)
	return _in(0xb7f70784, entity, _r, _s)
end

function Global.GetEntityType(entity)
	return _in(0xb1bd08d, entity, _r, _ri)
end

function Global.GetEntityVelocity(entity)
	return _in(0xc14c9b6b, entity, _r, _rv)
end

--- Gets the current game timer in milliseconds.
-- @return The game time.
function Global.GetGameTimer()
	return _in(0xa4ea0691, _r, _rl)
end

--- This native converts the passed string to a hash.
function Global.GetHashKey(model)
	return _in(0x98eff6f1, _ts(model), _r, _ri)
end

function Global.GetHostId()
	return _in(0x5f70f5a3, _r, _s)
end

function Global.GetInstanceId()
	return _in(0x9f1c4383, _r, _ri)
end

function Global.GetInvokingResource()
	return _in(0x4d52fe5b, _r, _s)
end

function Global.GetIsVehicleEngineRunning(vehicle)
	return _in(0x7dc6d022, vehicle, _r)
end

function Global.GetIsVehiclePrimaryColourCustom(vehicle)
	return _in(0xd7ec8760, vehicle, _r)
end

function Global.GetIsVehicleSecondaryColourCustom(vehicle)
	return _in(0x288ad228, vehicle, _r)
end

function Global.GetNumPlayerIdentifiers(playerSrc)
	return _in(0xff7f66ab, _ts(playerSrc), _r, _ri)
end

function Global.GetNumPlayerIndices()
	return _in(0x63d13184, _r, _ri)
end

--- Gets the amount of metadata values with the specified key existing in the specified resource's manifest.
-- See also: [Resource manifest](https://docs.fivem.net/resources/manifest/)
-- @param resourceName The resource name.
-- @param metadataKey The key to look up in the resource manifest.
function Global.GetNumResourceMetadata(resourceName, metadataKey)
	return _in(0x776e864, _ts(resourceName), _ts(metadataKey), _r, _ri)
end

function Global.GetNumResources()
	return _in(0x863f27b, _r, _ri)
end

function Global.GetPasswordHash(password)
	return _in(0x23473ea4, _ts(password), _r, _s)
end

function Global.GetPedArmour(ped)
	return _in(0x2ce311a7, ped, _r, _ri)
end

function Global.GetPedCauseOfDeath(ped)
	return _in(0x63458c27, ped, _r, _ri)
end

function Global.GetPedMaxHealth(ped)
	return _in(0xa45b6c8d, ped, _r, _ri)
end

function Global.GetPlayerEndpoint(playerSrc)
	return _in(0xfee404f9, _ts(playerSrc), _r, _s)
end

function Global.GetPlayerFromIndex(index)
	return _in(0xc8a9ce08, index, _r, _s)
end

function Global.GetPlayerGuid(playerSrc)
	return _in(0xe52d9680, _ts(playerSrc), _r, _s)
end

function Global.GetPlayerIdentifier(playerSrc, identifier)
	return _in(0x7302dbcf, _ts(playerSrc), identifier, _r, _s)
end

function Global.GetPlayerLastMsg(playerSrc)
	return _in(0x427e8e6a, _ts(playerSrc), _r, _ri)
end

function Global.GetPlayerName(playerSrc)
	return _in(0x406b4b20, _ts(playerSrc), _r, _s)
end

function Global.GetPlayerPed(playerSrc)
	return _in(0x6e31e993, _ts(playerSrc), _r, _ri)
end

function Global.GetPlayerPing(playerSrc)
	return _in(0xff1290d4, _ts(playerSrc), _r, _ri)
end

--- Returns all commands that are registered in the command system.
-- The data returned adheres to the following layout:
-- ```
-- [
-- {
-- "name": "cmdlist"
-- },
-- {
-- "name": "command1"
-- }
-- ]
-- ```
-- @return An object containing registered commands.
function Global.GetRegisteredCommands()
	return msgpack.unpack(_in(0xd4bef069, _r, _ro))
end

function Global.GetResourceByFindIndex(findIndex)
	return _in(0x387246b7, findIndex, _r, _s)
end

--- Gets the metadata value at a specified key/index from a resource's manifest.
-- See also: [Resource manifest](https://docs.fivem.net/resources/manifest/)
-- @param resourceName The resource name.
-- @param metadataKey The key in the resource manifest.
-- @param index The value index, in a range from [0..GET_NUM_RESOURCE_METDATA-1].
function Global.GetResourceMetadata(resourceName, metadataKey, index)
	return _in(0x964bab1d, _ts(resourceName), _ts(metadataKey), index, _r, _s)
end

--- Returns the physical on-disk path of the specified resource.
-- @param resourceName The name of the resource.
-- @return The resource directory name, possibly without trailing slash.
function Global.GetResourcePath(resourceName)
	return _in(0x61dcf017, _ts(resourceName), _r, _s)
end

--- Returns the current state of the specified resource.
-- @param resourceName The name of the resource.
-- @return The resource state. One of `"missing", "started", "starting", "stopped", "stopping", "uninitialized" or "unknown"`.
function Global.GetResourceState(resourceName)
	return _in(0x4039b485, _ts(resourceName), _r, _s)
end

function Global.GetVehicleBodyHealth(vehicle)
	return _in(0x2b2fcc28, vehicle, _r, _rf)
end

function Global.GetVehicleColours(vehicle)
	return _in(0x40d82d88, vehicle, _i, _i)
end

function Global.GetVehicleCustomPrimaryColour(vehicle)
	return _in(0x1c2b9fef, vehicle, _i, _i, _i)
end

function Global.GetVehicleCustomSecondaryColour(vehicle)
	return _in(0x3ff247a2, vehicle, _i, _i, _i)
end

function Global.GetVehicleDashboardColour(vehicle, color)
	return _in(0xa0dbd08d, vehicle, _ii(color) --[[ may be optional ]])
end

function Global.GetVehicleDirtLevel(vehicle)
	return _in(0xfd15c065, vehicle, _r, _rf)
end

--- enum VehicleLockStatus = {
-- None = 0,
-- Unlocked = 1,
-- Locked = 2,
-- LockedForPlayer = 3,
-- StickPlayerInside = 4, -- Doesn't allow players to exit the vehicle with the exit vehicle key.
-- CanBeBrokenInto = 7, -- Can be broken into the car. If the glass is broken, the value will be set to 1
-- CanBeBrokenIntoPersist = 8, -- Can be broken into persist
-- CannotBeTriedToEnter = 10, -- Cannot be tried to enter (Nothing happens when you press the vehicle enter key).
-- }
function Global.GetVehicleDoorLockStatus(vehicle)
	return _in(0xd72cef2, vehicle, _r, _ri)
end

function Global.GetVehicleDoorStatus(vehicle)
	return _in(0x6e35c49c, vehicle, _r, _ri)
end

--- Currently it only works when set to "all players".
function Global.GetVehicleDoorsLockedForPlayer(vehicle)
	return _in(0x1dc50247, vehicle, _r, _ri)
end

function Global.GetVehicleEngineHealth(vehicle)
	return _in(0x8880038a, vehicle, _r, _rf)
end

function Global.GetVehicleExtraColours(vehicle)
	return _in(0x80e4659b, vehicle, _i, _i)
end

function Global.GetVehicleHandbrake(vehicle)
	return _in(0x483b013c, vehicle, _r)
end

function Global.GetVehicleHeadlightsColour(vehicle)
	return _in(0xd7147656, vehicle, _r, _ri)
end

function Global.GetVehicleInteriorColour(vehicle, color)
	return _in(0xccff3b6e, vehicle, _ii(color) --[[ may be optional ]])
end

function Global.GetVehicleLightsState(vehicle)
	return _in(0x7c278621, vehicle, _i --[[ actually bool ]], _i --[[ actually bool ]], _r)
end

function Global.GetVehicleLivery(vehicle)
	return _in(0xec82a51d, vehicle, _r, _ri)
end

function Global.GetVehicleNumberPlateText(vehicle)
	return _in(0xe8522d58, vehicle, _r, _s)
end

function Global.GetVehicleNumberPlateTextIndex(vehicle)
	return _in(0x499747b6, vehicle, _r, _ri)
end

function Global.GetVehiclePetrolTankHealth(vehicle)
	return _in(0xe41595ce, vehicle, _r, _rf)
end

function Global.GetVehicleRadioStationIndex(vehicle)
	return _in(0x57037960, vehicle, _r, _ri)
end

function Global.GetVehicleRoofLivery(vehicle)
	return _in(0x872cf42, vehicle, _r, _ri)
end

function Global.GetVehicleTyreSmokeColor(vehicle)
	return _in(0x75280015, vehicle, _i, _i, _i)
end

function Global.GetVehicleWheelType(vehicle)
	return _in(0xda58d7ae, vehicle, _r, _ri)
end

function Global.GetVehicleWindowTint(vehicle)
	return _in(0x13d53892, vehicle, _r, _ri)
end

function Global.HasEntityBeenMarkedAsNoLongerNeeded(vehicle)
	return _in(0x9c9a3be0, vehicle, _r)
end

function Global.HasVehicleBeenOwnedByPlayer(vehicle)
	return _in(0xe4e83a5b, vehicle, _r)
end

function Global.InvokeFunctionReference(referenceIdentity, argsSerialized, argsLength, retvalLength)
	return _in(0xe3551879, _ts(referenceIdentity), _ts(argsSerialized), argsLength, _ii(retvalLength) --[[ may be optional ]], _r, _s)
end

function Global.IsAceAllowed(object)
	return _in(0x7ebb9929, _ts(object), _r)
end

--- Gets whether or not this is the CitizenFX server.
-- @return A boolean value.
function Global.IsDuplicityVersion()
	return _in(0xcf24c52e, _r)
end

function Global.IsPlayerAceAllowed(playerSrc, object)
	return _in(0xdedae23d, _ts(playerSrc), _ts(object), _r)
end

--- Requests whether or not the commerce data for the specified player has loaded.
-- @param playerSrc The player handle
-- @return A boolean.
function Global.IsPlayerCommerceInfoLoaded(playerSrc)
	return _in(0xbefe93f4, _ts(playerSrc), _r)
end

function Global.IsPrincipalAceAllowed(principal, object)
	return _in(0x37cf52ce, _ts(principal), _ts(object), _r)
end

function Global.IsVehicleEngineStarting(vehicle)
	return _in(0xbb340d04, vehicle, _r)
end

function Global.IsVehicleSirenOn(vehicle)
	return _in(0x25eb5873, vehicle, _r)
end

function Global.IsVehicleTyreBurst(vehicle, wheelID, completely)
	return _in(0x48c80210, vehicle, wheelID, completely, _r)
end

--- Requests the commerce data for the specified player, including the owned SKUs. Use `IS_PLAYER_COMMERCE_INFO_LOADED` to check if it has loaded.
-- @param playerSrc The player handle
function Global.LoadPlayerCommerceData(playerSrc)
	return _in(0xa8f63eab, _ts(playerSrc))
end

--- Reads the contents of a text file in a specified resource.
-- If executed on the client, this file has to be included in `files` in the resource manifest.
-- Example: `local data = LoadResourceFile("devtools", "data.json")`
-- @param resourceName The resource name.
-- @param fileName The file in the resource.
-- @return The file contents
function Global.LoadResourceFile(resourceName, fileName)
	return _in(0x76a9ee1f, _ts(resourceName), _ts(fileName), _r, _s)
end

function Global.NetworkGetEntityFromNetworkId(netId)
	return _in(0x5b912c3f, netId, _r, _ri)
end

--- Returns the owner ID of the specified entity.
-- @param entity The entity to get the owner for.
-- @return On the server, the server ID of the entity owner. On the client, returns the player/slot ID of the entity owner.
function Global.NetworkGetEntityOwner(entity)
	return _in(0x526fee31, entity, _r, _ri)
end

function Global.NetworkGetNetworkIdFromEntity(entity)
	return _in(0x9e35dab6, entity, _r, _ri)
end

function Global.PerformHttpRequestInternal(requestData, requestDataLength)
	return _in(0x8e8cc653, _ts(requestData), requestDataLength, _r, _ri)
end

--- Scope entry for profiler.
-- @param scopeName Scope name.
function Global.ProfilerEnterScope(scopeName)
	return _in(0xc795a4a9, _ts(scopeName))
end

--- Scope exit for profiler.
function Global.ProfilerExitScope()
	return _in(0xb39ca35c)
end

--- Returns true if the profiler is active.
-- @return True or false.
function Global.ProfilerIsRecording()
	return _in(0xf8b7d7bb, _r)
end

--- Registered commands can be executed by entering them in the client console (this works for client side and server side registered commands). Or by entering them in the server console/through an RCON client (only works for server side registered commands). Or if you use a supported chat resource, like the default one provided in the cfx-server-data repository, then you can enter the command in chat by prefixing it with a `/`.
-- Commands registered using this function can also be executed by resources, using the [`ExecuteCommand` native](#_0x561C060B).
-- The restricted bool is not used on the client side. Permissions can only be checked on the server side, so if you want to limit your command with an ace permission automatically, make it a server command (by registering it in a server script).
-- **Example result**:
-- ![](https://i.imgur.com/TaCnG09.png)
-- @param commandName The command you want to register.
-- @param handler A handler function that gets called whenever the command is executed.
-- @param restricted If this is a server command and you set this to true, then players will need the command.yourCommandName ace permission to execute this command.
function Global.RegisterCommand(commandName, handler, restricted)
	return _in(0x5fa79b0f, _ts(commandName), _mfr(handler), restricted)
end

--- Registers a listener for console output messages.
-- @param listener A function of `(channel: string, message: string) => void`. The message might contain `\n`.
function Global.RegisterConsoleListener(listener)
	return _in(0x281b5448, _mfr(listener))
end

--- An internal function which allows the current resource's HLL script runtimes to receive state for the specified event.
-- @param eventName An event name, or "\*" to disable HLL event filtering for this resource.
function Global.RegisterResourceAsEventHandler(eventName)
	return _in(0xd233a168, _ts(eventName))
end

--- **Experimental**: This native may be altered or removed in future versions of CitizenFX without warning.
-- Registers a cached resource asset with the resource system, similar to the automatic scanning of the `stream/` folder.
-- @param resourceName The resource to add the asset to.
-- @param fileName A file name in the resource.
-- @return A cache string to pass to `REGISTER_STREAMING_FILE_FROM_CACHE` on the client.
function Global.RegisterResourceAsset(resourceName, fileName)
	return _in(0x9862b266, _ts(resourceName), _ts(fileName), _r, _s)
end

--- Registers a build task factory for resources.
-- The function should return an object (msgpack map) with the following fields:
-- ```
-- {
-- // returns whether the specific resource should be built
-- shouldBuild = func(resourceName: string): bool,
-- // asynchronously start building the specific resource.
-- // call cb when completed
-- build = func(resourceName: string, cb: func(success: bool, status: string): void): void
-- }
-- ```
-- @param factoryId The identifier for the build task.
-- @param factoryFn The factory function.
function Global.RegisterResourceBuildTaskFactory(factoryId, factoryFn)
	return _in(0x285b43ca, _ts(factoryId), _mfr(factoryFn))
end

--- Requests the specified player to buy the passed SKU. This'll pop up a prompt on the client, which upon acceptance
-- will open the browser prompting further purchase details.
-- @param playerSrc The player handle
-- @param skuId The ID of the SKU.
function Global.RequestPlayerCommerceSession(playerSrc, skuId)
	return _in(0x96f93cce, _ts(playerSrc), skuId)
end

--- Writes the specified data to a file in the specified resource.
-- Using a length of `-1` will automatically detect the length assuming the data is a C string.
-- @param resourceName The name of the resource.
-- @param fileName The name of the file.
-- @param data The data to write to the file.
-- @param dataLength The length of the written data.
-- @return A value indicating if the write succeeded.
function Global.SaveResourceFile(resourceName, fileName, data, dataLength)
	return _in(0xa09e7e7b, _ts(resourceName), _ts(fileName), _ts(data), dataLength, _r)
end

--- Schedules the specified resource to run a tick as soon as possible, bypassing the server's fixed tick rate.
-- @param resourceName The resource to tick.
function Global.ScheduleResourceTick(resourceName)
	return _in(0xb88a73ad, _ts(resourceName))
end

function Global.SetConvar(varName, value)
	return _in(0x341b16d2, _ts(varName), _ts(value))
end

function Global.SetConvarReplicated(varName, value)
	return _in(0xf292858c, _ts(varName), _ts(value))
end

function Global.SetConvarServerInfo(varName, value)
	return _in(0x9338d547, _ts(varName), _ts(value))
end

--- ```
-- p7 is always 1 in the scripts. Set to 1, an area around the destination coords for the moved entity is cleared from other entities.
-- Often ends with 1, 0, 0, 1); in the scripts. It works.
-- Axis - Invert Axis Flags
-- ```
-- Sets an entity's coordinates in world space.
-- @param entity The entity to change coordinates for.
-- @param xPos The x coordinate.
-- @param yPos The y coordinate.
-- @param zPos The z coordinate.
-- @param xAxis Whether to invert x axis.
-- @param yAxis Whether to invert y axis.
-- @param zAxis Whether to invert z axis.
-- @param clearArea Whether to clear other entities in area around entity.
function Global.SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
	return _in(0xdf70b41b, entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
end

--- Set the heading of an entity in degrees also known as "Yaw".
-- @param entity The entity to set the heading for.
-- @param heading The heading in degrees.
function Global.SetEntityHeading(entity, heading)
	return _in(0xe0ff064d, entity, heading)
end

--- rotationOrder refers to the order yaw pitch roll is applied
-- value ranges from 0 to 5. What you use for rotationOrder when setting must be the same as rotationOrder when getting the rotation.
-- Unsure what value corresponds to what rotation order, more testing will be needed for that.
-- For the most part R* uses 1 or 2 as the order.
-- p5 is usually set as true
function Global.SetEntityRotation(entity, pitch, roll, yaw, rotationOrder, p5)
	return _in(0xa345efe, entity, pitch, roll, yaw, rotationOrder, p5)
end

--- Note that the third parameter(denoted as z) is "up and down" with positive ment.
function Global.SetEntityVelocity(entity, x, y, z)
	return _in(0xff5a1988, entity, x, y, z)
end

function Global.SetGameType(gametypeName)
	return _in(0xf90b7469, _ts(gametypeName))
end

function Global.SetHttpHandler(handler)
	return _in(0xf5c6330c, _mfr(handler))
end

function Global.SetMapName(mapName)
	return _in(0xb7ba82dc, _ts(mapName))
end

--- Ped: The ped to warp.
-- vehicle: The vehicle to warp the ped into.
-- Seat_Index: [-1 is driver seat, -2 first free passenger seat]
-- Moreinfo of Seat Index
-- DriverSeat = -1
-- Passenger = 0
-- Left Rear = 1
-- RightRear = 2
function Global.SetPedIntoVehicle(ped, vehicle, seatIndex)
	return _in(0x7500c79, ped, vehicle, seatIndex)
end

--- Call SET_PLAYER_WANTED_LEVEL_NOW for immediate effect
-- wantedLevel is an integer value representing 0 to 5 stars even though the game supports the 6th wanted level but no police will appear since no definitions are present for it in the game files
-- disableNoMission-  Disables When Off Mission- appears to always be false
function Global.SetPlayerWantedLevel(player, wantedLevel, disableNoMission)
	return _in(0xb7a0914b, player, wantedLevel, disableNoMission)
end

--- colorPrimary & colorSecondary are the paint index for the vehicle.
-- For a list of valid paint indexes, view: pastebin.com/pwHci0xK
-- -------------------------------------------------------------------------
-- Use this to get the number of color indices: pastebin.com/RQEeqTSM
-- Note: minimum color index is 0, maximum color index is (numColorIndices - 1)
function Global.SetVehicleColours(vehicle, colorPrimary, colorSecondary)
	return _in(0x57f24253, vehicle, colorPrimary, colorSecondary)
end

function Global.StartResource(resourceName)
	return _in(0x29b440dc, _ts(resourceName), _r)
end

function Global.StopResource(resourceName)
	return _in(0x21783161, _ts(resourceName), _r)
end

function Global.TempBanPlayer(playerSrc, reason)
	return _in(0x1e35dbba, _ts(playerSrc), _ts(reason))
end

--- The backing function for TriggerClientEvent.
function Global.TriggerClientEventInternal(eventName, eventTarget, eventPayload, payloadLength)
	return _in(0x2f7a49e6, _ts(eventName), _ts(eventTarget), _ts(eventPayload), payloadLength)
end

--- The backing function for TriggerEvent.
function Global.TriggerEventInternal(eventName, eventPayload, payloadLength)
	return _in(0x91310870, _ts(eventName), _ts(eventPayload), payloadLength)
end

--- The backing function for TriggerLatentClientEvent.
function Global.TriggerLatentClientEventInternal(eventName, eventTarget, eventPayload, payloadLength, bps)
	return _in(0x70b35890, _ts(eventName), _ts(eventTarget), _ts(eventPayload), payloadLength, bps)
end

function Global.VerifyPasswordHash(password, hash)
	return _in(0x2e310acd, _ts(password), _ts(hash), _r)
end

--- Returns whether or not the currently executing event was canceled.
-- @return A boolean.
function Global.WasEventCanceled()
	return _in(0x58382a19, _r)
end

