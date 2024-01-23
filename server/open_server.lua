local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback("pik-multicharacter:server:setupCharacters", function(source, cb)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    local result = ExecuteSql("SELECT * FROM players WHERE license = '"..license.."'")
    for i = 1, (#result), 1 do
        result[i].charinfo = json.decode(result[i].charinfo)
        result[i].money = json.decode(result[i].money)
        result[i].job = json.decode(result[i].job)
        plyChars[#plyChars+1] = result[i]
    end
    cb(plyChars)
end)

QBCore.Functions.CreateCallback("pik-multicharacter:server:getSkin", function(source, cb, cid)
    local result = exports.oxmysql:executeSync('SELECT * FROM player_outfits WHERE citizenid = ?', {cid})
    if result[1] ~= nil then
        cb(result[1].model, result[1].appearance)
    else
        cb(nil)
    end
end)


function GiveStarterItems(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for _, v in pairs(PIK.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end


function loadHouseData(src)
    local HouseGarages = {}
    local Houses = {}
    local result = ExecuteSql('SELECT * FROM houselocations')
    if result[1] ~= nil then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("qb-garages:client:houseGarageConfig", src, HouseGarages)
    TriggerClientEvent("qb-houses:client:setHouseConfig", src, Houses)
end


RegisterNetEvent("pik-multicharacter:server:loadUserData", function(cData)
    local src = source
    if QBCore.Player.Login(src, cData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        print('^2[qb-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData..') has succesfully loaded!')
        QBCore.Commands.Refresh(src)
        local varS = {
            citizenid = cData
        }
        if PIK.UseQbApartments then 
            loadHouseData(src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, varS)
        else
            TriggerClientEvent('qb-spawn:client:setupSpawns', src, varS, false, nil)
            TriggerClientEvent('qb-spawn:client:openUI', src, true)
        end
        TriggerEvent("qb-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined') .." |  ||"  ..(QBCore.Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.." | "..src..") loaded..")
    end
end)
