-- ==============================================================
-- ox_target <-> qb-target bridge (Client)
-- Supports: model, entity, vehicle, ped, box/sphere zones, globals
-- Includes: event passthrough
-- ==============================================================

local useOx = GetConvarInt('UseOxTarget', 1) == 1
local oxTarget = exports['ox_target']
local qbTarget = exports['qb-target']

local function usingOx()
    return useOx and oxTarget
end

-- ==============================================================
-- ADD TARGETS
-- ==============================================================

local function AddModelTarget(models, options)
    if usingOx() then oxTarget:addModel(models, options)
    else qbTarget:AddTargetModel(models, options) end
end
exports('AddModelTarget', AddModelTarget)

local function AddEntityTarget(entity, options)
    if usingOx() then oxTarget:addEntity(entity, options)
    else qbTarget:AddTargetEntity(entity, options) end
end
exports('AddEntityTarget', AddEntityTarget)

local function AddPedTarget(peds, options)
    if usingOx() then oxTarget:addModel(peds, options)
    else qbTarget:AddTargetModel(peds, options) end
end
exports('AddPedTarget', AddPedTarget)

local function AddVehicleTarget(vehicles, options)
    if usingOx() then oxTarget:addModel(vehicles, options)
    else qbTarget:AddTargetModel(vehicles, options) end
end
exports('AddVehicleTarget', AddVehicleTarget)

local function AddBoxZoneTarget(name, center, length, width, options, targetOptions)
    if usingOx() then
        oxTarget:addBoxZone({
            name = name,
            coords = center,
            size = vec3(length, width, options.height or 3.0),
            rotation = options.heading or 0,
            debug = options.debug or false,
            options = targetOptions
        })
    else
        qbTarget:AddBoxZone(name, center, length, width, options, targetOptions)
    end
end
exports('AddBoxZoneTarget', AddBoxZoneTarget)

local function AddSphereZoneTarget(name, coords, radius, options)
    if usingOx() then
        oxTarget:addSphereZone({
            name = name,
            coords = coords,
            radius = radius,
            debug = options.debug or false,
            options = options.targets or {}
        })
    else
        qbTarget:AddCircleZone(name, coords, radius, options, options.targets or {})
    end
end
exports('AddSphereZoneTarget', AddSphereZoneTarget)

local function AddGlobalPedTarget(options)
    if usingOx() then oxTarget:addGlobalPed(options)
    else qbTarget:AddGlobalPed(options) end
end
exports('AddGlobalPedTarget', AddGlobalPedTarget)

local function AddGlobalVehicleTarget(options)
    if usingOx() then oxTarget:addGlobalVehicle(options)
    else qbTarget:AddGlobalVehicle(options) end
end
exports('AddGlobalVehicleTarget', AddGlobalVehicleTarget)

-- ==============================================================
-- REMOVE TARGETS
-- ==============================================================

local function RemoveTarget(id)
    if usingOx() then oxTarget:removeZone(id)
    else qbTarget:RemoveZone(id) end
end
exports('RemoveTarget', RemoveTarget)

-- ==============================================================
-- EVENT PASSTHROUGH
-- ==============================================================

-- Handles forwarding of client-side target events to server automatically
RegisterNetEvent('bridge:triggerServerEvent', function(eventName, args)
    TriggerServerEvent('bridge:serverEventHandler', eventName, args)
end)

-- Intercept ox_target / qb-target client events to auto bridge them
RegisterNetEvent('bridge:clientEventHandler', function(eventName, args)
    if eventName then
        TriggerEvent(eventName, args)
    end
end)

RegisterCommand('target_backend', function()
    print('Current target backend:', usingOx() and 'ox_target' or 'qb-target')
end, false)

print('[Bridge] Loaded using ' .. (usingOx() and 'ox_target' or 'qb-target'))
