local QBCore = exports['qb-core']:GetCoreObject()
if PIK.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif PIK.Framework == "oldqb" then 
    QBCore = nil
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
end

hasDonePreloading = {}

-- Functions

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000) -- 1 second should be enough to do the preloading in other resources
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('pik-multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, "Disconnected")
end)

RegisterNetEvent('pik-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if QBCore.Player.Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        if PIK.UseQbApartments then 
            if Apartments.Starting then
                local randbucket = (GetPlayerPed(src) .. math.random(1,999))
                SetPlayerRoutingBucket(src, randbucket)
                print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
                QBCore.Commands.Refresh(src)
                loadHouseData(src)
                TriggerClientEvent("pik-multicharacter:client:closeNUI", src)
                TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
                GiveStarterItems(src)
            else
                print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
                QBCore.Commands.Refresh(src)
                loadHouseData(src)
                TriggerClientEvent("pik-multicharacter:client:closeNUIdefault", src)
                GiveStarterItems(src)
            end
        else
            local randbucket = (GetPlayerPed(src) .. math.random(1,999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            QBCore.Commands.Refresh(src)
            TriggerClientEvent("pik-multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
        end
    end
end)

RegisterNetEvent('pik-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    QBCore.Player.DeleteCharacter(src, citizenid)
    TriggerClientEvent('QBCore:Notify', src, Lang:t("notifications.char_deleted") , "success")
end)

-- Callbacks

QBCore.Functions.CreateCallback("pik-multicharacter:server:GetUserCharacters", function(source, cb)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license')

    local result = ExecuteSql("SELECT * FROM players WHERE license = '"..license.."' ")
    cb(result)
end)

QBCore.Functions.CreateCallback("pik-multicharacter:server:GetServerLogs", function(_, cb)
    local result = ExecuteSql('SELECT * FROM server_logs')
    cb(result)
end)

QBCore.Functions.CreateCallback("pik-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license')
    local numOfChars = 0
    local addedCount = 0

    local callBackData = {}

    if next(PIK.PlayersNumberOfCharacters) then
        for _, v in pairs(PIK.PlayersNumberOfCharacters) do
            if v.license == license then
                numOfChars = v.numberOfChars
                break
            else
                numOfChars = PIK.DefaultNumberOfCharacters
            end
        end
    else
        numOfChars = PIK.DefaultNumberOfCharacters
    end
    local result = ExecuteSql("SELECT * FROM pik_multichar WHERE license = '"..license.."'")
    if result[1] then 
        addedCount = result[1].charCount
    end

    callBackData = {
        numOfChars = numOfChars,
        addedCount = addedCount,
    }
    cb(callBackData)
end)

QBCore.Functions.CreateCallback('pik-multicharacter:sendInput', function(source, cb, data)
    local _source = source
    local inputData = data.inputData
    local result = ExecuteSql("SELECT * FROM pik_multichar_codes WHERE code = '"..inputData.."'")
    if result[1] ~= nil then
        ExecuteSql("DELETE FROM pik_multichar_codes WHERE code = '"..inputData.."'")
        local license = QBCore.Functions.GetIdentifier(_source, 'license')
        local result2 = ExecuteSql("SELECT * FROM pik_multichar WHERE license = '"..license.."'")
        if result2[1] ~= nil then 
            ExecuteSql("UPDATE pik_multichar SET charCount = charCount + 1 WHERE license = '"..license.."'")
        else
            ExecuteSql("INSERT INTO pik_multichar (license, charCount) VALUES ('"..license.."', 1)")
        end
        cb(true)
    else
        cb(false)
    end
end)

RegisterCommand('purchase_multichar_slot', function(source, args)
	local src = source
    if src == 0 then
        local dec = json.decode(args[1])
        local tbxid = dec.transid
        local credit = dec.credit
        while inProgress do
            Wait(1000)
        end
        inProgress = true
        local result = ExecuteSql("SELECT * FROM pik_multichar_codes WHERE code = '"..tbxid.."'")
        if result[1] == nil then
            ExecuteSql("INSERT INTO pik_multichar_codes (code) VALUES ('"..tbxid.."')")
        end
        inProgress = false  
    end
end)

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if PIK.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif PIK.Mysql == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif PIK.Mysql == "mysql-async" then   
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end