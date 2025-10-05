-- ==============================================================
-- ox_target <-> qb-target bridge (Server)
-- Handles event passthrough for compatibility between target systems
-- ==============================================================

RegisterNetEvent('bridge:serverEventHandler', function(eventName, args)
    local src = source
    if not eventName then return end

    -- Trigger as if called normally
    TriggerEvent(eventName, src, args)
end)

-- Optional debug log
print('[Bridge] Server-side event passthrough active')
