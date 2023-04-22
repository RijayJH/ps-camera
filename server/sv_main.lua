local QBCore = exports['qb-core']:GetCoreObject()

-- Add Discord webhook here.
local webhook = ""

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent("ps-camera:requestWebhook", function(Key)
    local source = source
    local event = ("ps-camera:grabbed%s"):format(Key)
    TriggerClientEvent(event, source, webhook)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url)
    local source = source
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    local coords = GetEntityCoords(GetPlayerPed(source))

    TriggerClientEvent("ps-camera:getStreetName", source, url, coords)
end)

RegisterNetEvent("ps-camera:savePhoto", function(url, streetName)
    local source = source
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    local location = streetName

    local info = {
        image = url,
        location = location
    }
    exports.ox_inventory:AddItem(source, "photo", 1, info)
end)


QBCore.Functions.CreateUseableItem("camera", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if exports.ox_inventory:GetItem(source, item.name, nil, true) > 0 then
        TriggerClientEvent("ps-camera:useCamera", source)
    end
end)

QBCore.Functions.CreateUseableItem("photo", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if exports.ox_inventory:GetItem(source, item.name, nil, true) > 0 then
        TriggerClientEvent("ps-camera:usePhoto", source, item.metadata.image, item.metadata.location)
    end
end)

function UseCam(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if exports.ox_inventory:GetItem(src, 'camera', nil, true) > 0 then
        TriggerClientEvent("ps-camera:useCamera", src)
    else
        TriggerClientEvent('QBCore:Notify', src, "U don\'t have a camera", "error")
    end
end

exports("UseCam", UseCam)
