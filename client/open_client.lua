local QBCore = exports['qb-core']:GetCoreObject()
RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        if cData.cData ~= nil then 
            QBCore.Functions.TriggerCallback('pik-multicharacter:server:getSkin', function(model, data)
                model = model ~= nil and tonumber(model) or false
                if model ~= nil then
                    CreateThread(function()
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(0)
                        end
                        charPed = CreatePed(2, model, PIK.PedCoords.x, PIK.PedCoords.y, PIK.PedCoords.z - 0.98, PIK.PedCoords.w, false, true)
                        SetPedComponentVariation(charPed, 0, 0, 0, 2)
                        FreezeEntityPosition(charPed, false)
                        SetEntityInvincible(charPed, true)
                        PlaceObjectOnGroundProperly(charPed)
                        SetBlockingOfNonTemporaryEvents(charPed, true)
                        data = json.decode(data)
                        exports['fivem-appearance']:setPedAppearance(a)
                    end)
                else
                    CreateThread(function()
                        local randommodels = {
                            "mp_m_freemode_01",
                        }
                        model = joaat(randommodels[math.random(1, #randommodels)])
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(0)
                        end
                        charPed = CreatePed(2, model, PIK.PedCoords.x, PIK.PedCoords.y, PIK.PedCoords.z - 0.98, PIK.PedCoords.w, false, true)
                        SetPedComponentVariation(charPed, 0, 0, 0, 2)
                        FreezeEntityPosition(charPed, false)
                        SetEntityInvincible(charPed, true)
                        PlaceObjectOnGroundProperly(charPed)
                        SetBlockingOfNonTemporaryEvents(charPed, true)
                    end)
                end
                cb("ok")
            end, cData.cData)
        else
            CreateThread(function()
                local ped = "mp_m_freemode_01"
                if cData.sex == "female" then 
                    ped = "mp_f_freemode_01"
                end
                local model = joaat(ped)
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end
                charPed = CreatePed(2, model, PIK.PedCoords.x, PIK.PedCoords.y, PIK.PedCoords.z - 0.98, PIK.PedCoords.w, false, true)
                SetPedComponentVariation(charPed, 0, 0, 0, 2)
                FreezeEntityPosition(charPed, false)
                SetEntityInvincible(charPed, true)
                PlaceObjectOnGroundProperly(charPed)
                SetBlockingOfNonTemporaryEvents(charPed, true)
            end)
            cb("ok")
        end 
    else
        CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = joaat(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, PIK.PedCoords.x, PIK.PedCoords.y, PIK.PedCoords.z - 0.98, PIK.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
        cb("ok")
    end
end)
