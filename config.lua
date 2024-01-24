PIK = {}

PIK.Framework = "qb" -- qb / oldqb | qb = export system | oldqb = triggerevent system
PIK.Mysql = "oxmysql" -- Check fxmanifest.lua when you change it! | ghmattimysql / oxmysql / mysql-async
PIK.tebexLink = "https://pik-sutdios.tebex.io/category/script-testing"

/* RO LANGUAGE | LIMBA ROMANA
PIK.Translate = {
    title = "PIK",
    character = "Selecteaza",
    selector = "un Caracter",
    firstDesc = "",
    createCharacter = "Creeaza Caracter",
    buySlot = "CUMPARA SLOT",
    play = "JOACA",
    delete = "STERGE",
    male = "BARBAT",
    female = "FEMEIE",
    dateOfBirth = "DATA NASTERII",
    nationality = "NATIONALITATE",
    job = "JOB",
    cash = "BANI CASH",
    bank = "BANCA",
    phoneNumber = "NUMAR DE TELEFON",
    accountNumber = "IBAN",
    rightTitle1 = "Creeaza",
    rightTitle2 = "Caracter",
    rightDescription = "Creeazati un caracter! Completeaza toate campurile de mai jos!",
    name = "NUME",
    surname = "PRENUME",
    create = "CREEAZA",
    slot = "SLOT",
    redeemCode = "REVENDICA COD",
    buyCode = "CUMPARA COD",
    cancel = "ANULEAZA",
    accept = "ACCEPTA",
    characterInfo = "INFORMATII CARACTER",
    loading = "SE INCARCA!",
    plsWait = "TE RUGAM SA ASTEPTI...",  
    doYouAgreeDelete = "ESTI SIGUR CA VREI SA STERGI ACEST CARACTER?",
} */

-- EN LANGUAGE | LIMBA ENGLEZA
PIK.Translate = {
    title = "PIK",
    character = "Characters",
    selector = "Selector",
    firstDesc = "",
    createCharacter = "Create Character",
    buySlot = "BUY SLOT",
    play = "PLAY",
    delete = "DELETE",
    male = "MALE",
    female = "FEMALE",
    dateOfBirth = "DATE OF BIRTH",
    nationality = "NATIONALITY",
    job = "JOB",
    cash = "CASH",
    bank = "BANK",
    phoneNumber = "PHONE NUMBER",
    accountNumber = "IBAN",
    rightTitle1 = "Create",
    rightTitle2 = "Character",
    rightDescription = "Create an character! Fill out the form to start playing",
    name = "NAME",
    surname = "SURNAME",
    create = "CREATE",
    slot = "SLOT",
    redeemCode = "REDEEM CODE",
    buyCode = "BUY CODE",
    cancel = "CANCEL",
    accept = "ACCEPT",
    characterInfo = "CHARACTERS INFORMATIONS",
    loading = "LOADING!",
    plsWait = "PLEASE WAIT...",  
    doYouAgreeDelete = "DO YOU WANT TO DELETE THE CHARACTER ?",
}

PIK.MaxCharSlot = 2
PIK.DefaultOpenCharSlot = 1

PIK.UseQbApartments = true -- Default = false | If you want to use qb-apartaments set it to true

PIK.Interior = vector3(406.74, -953.56, -99.0) -- Interior to load where characters are previewed
PIK.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled
PIK.PedCoords = vector4(406.68, -953.71, -100.0, 334.91) -- Create preview ped at these coordinates
PIK.HiddenCoords = vector4(-812.23, 182.54, 76.74, 156.5) -- Hides your actual ped while you are in selection
PIK.CamCoords = vector4(407.59, -951.7, -99.0, 155.91) -- Camera coordinates for character preview screen
PIK.EnableDeleteButton = true -- doesnt work now, i will release an update

PIK.DefaultNumberOfCharacters = 2 -- Define maximum amount of default characters (maximum 5 characters defined by default)
PIK.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
    { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 2 },
}

PIK.StarterItems = {
    {item = "id_card", amount = 1},
    {item = "phone", amount = 1},
    -- {item = "buyukburger", amount = 2},
    -- {item = "sisekola", amount = 2},
    -- {item = "water", amount = 3},
    -- {item = "burger", amount = 3},
    -- {item = "phone", amount = 1},
}

PIK.PlayerLoaded = function(citizenId)

end

