local QBCore = exports['qb-core']:GetCoreObject()
cam = nil
charPed = nil
opened = false
if PIK.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif PIK.Framework == "oldqb" then 
    QBCore = nil
end

-- Main Thread

CreateThread(function()
    if PIK.Framework == "oldqb" then 
        while QBCore == nil do
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
	elseif PIK.Framework == "qb" then
		while QBCore == nil do
            Citizen.Wait(200)
        end
    end
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('pik-multicharacter:client:chooseCharX')
			return
		end
	end
end)

-- Functions

function skyCam(bool)
    TriggerEvent('qb-weathersync:client:DisableSync')
    if bool then
        SetTimecycleModifier('default')
        DoScreenFadeIn(1000)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PIK.CamCoords.x, PIK.CamCoords.y, PIK.CamCoords.z, 0.0 ,0.0, PIK.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
  
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
    SetNuiFocus(bool, bool)
end

function openCharMenu(bool)
    QBCore.Functions.TriggerCallback("pik-multicharacter:server:GetNumberOfCharacters", function(result)
        local defaultOpenCharSlot = PIK.DefaultOpenCharSlot + result.addedCount
        if bool then 
            while not opened do 
                SetNuiFocus(bool, bool)
                SendNUIMessage({
                    action = "ui",
                    toggle = bool,
                    nChar = result.numOfChars,
                    enableDeleteButton = PIK.EnableDeleteButton,
                    defaultCharCount = PIK.MaxCharSlot,
                    mySlotCount = defaultOpenCharSlot,
                    translate = PIK.Translate,
                    tebexLink = PIK.TebexLink,
                })
                Wait(1000)
            end
        else
            SetNuiFocus(bool, bool)
            SendNUIMessage({
                action = "ui",
                toggle = bool,
                nChar = result.numOfChars,
                enableDeleteButton = PIK.EnableDeleteButton,
                defaultCharCount = PIK.MaxCharSlot,
                mySlotCount = defaultOpenCharSlot,
                translate = PIK.Translate,
                tebexLink = PIK.TebexLink,
            })
        end
        skyCam(bool)
    end)
end


-- Events

RegisterNetEvent('pik-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), PIK.DefaultSpawn.x, PIK.DefaultSpawn.y, PIK.DefaultSpawn.z)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('ndevClothing:CreateFirstCharacter')
end)

RegisterNetEvent('pik-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    TriggerEvent('ndevClothing:CreateFirstCharacter')
end)

RegisterNetEvent('pik-multicharacter:client:chooseCharX', function()
    SetNuiFocus(false, false)
    local interior = GetInteriorAtCoords(PIK.Interior.x, PIK.Interior.y, PIK.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), PIK.HiddenCoords.x, PIK.HiddenCoords.y, PIK.HiddenCoords.z)
    -- Wait(1500)

    openCharMenu(true)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    openCharMenu(false)
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('pik-multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    PIK.PlayerLoaded(cData)
    TriggerServerEvent('pik-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
    TriggerEvent("cdev-spawn:opennui")
end)

RegisterNUICallback('setupCharacters', function(_, cb)
    QBCore.Functions.TriggerCallback("pik-multicharacter:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        cb("ok")
    end)
end)

RegisterNUICallback('refreshCharacters', function(_, cb)
    QBCore.Functions.TriggerCallback("pik-multicharacter:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "refreshCharacters",
            characters = result
        })
        cb("ok")
    end)
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb, gender)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "male" then
        cData.gender = 0
    elseif cData.gender == "female" then
        cData.gender = 1
    end
    TriggerServerEvent('pik-multicharacter:server:createCharacter', cData)
    Wait(500)
    cb("ok")
    TriggerEvent("pik-multicharacter:client:closeNUI", src)
    TriggerEvent('ndevClothing:CreateFirstCharacter', gender)
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('pik-multicharacter:server:deleteCharacter', data.citizenid)
    DeletePed(charPed)
    opened = false
    TriggerEvent('pik-multicharacter:client:chooseCharX')
    cb("ok")
end)

local sendInputProtect = 0
RegisterNUICallback('sendInput', function(data, cb)
    if sendInputProtect < GetGameTimer() then 
        sendInputProtect = GetGameTimer() + 1500
        QBCore.Functions.TriggerCallback("pik-multicharacter:sendInput", function(result)
            if result then 
                DeletePed(charPed)
                opened = false
                TriggerEvent('pik-multicharacter:client:chooseCharX')
            end
            cb(result)
        end, data)
    end
end)

RegisterNUICallback('started', function(_, cb)
    opened = true
end)