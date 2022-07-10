local pedDisplaying = {}

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 350
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.0)
        SetTextFont(0)
        SetTextProportional(1)

        SetTextColour(188, 188, 188, 0)
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(true)
        AddTextComponentSubstringPlayerName(text)
        ClearDrawOrigin()

        DrawText(_x,_y)
    end
  end
function Display(ped, text, isim)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    if dist <= 50 then
        TriggerEvent('chat:addMessage', {template = '<div class="chat-message do" style="background-color: rgba(180,180,180,60%); color:#fff"><b>' .. isim .. '</b>: ' .. text .. '</div>'})   
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true
        Citizen.CreateThread(function()
            Wait(7000)
            display = false
        end)
        local offset = 0.2 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(x, y, z, text)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

RegisterNetEvent('3dzar:shareDisplay')
AddEventHandler('3dzar:shareDisplay', function(isim, text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text, isim)
    end
end)

TriggerEvent('chat:addSuggestion', '/ooc', 'His - soyut anlam belirtmek için emote kullanımı.', { name = 'action', help = '"scratch his nose" for example.'})