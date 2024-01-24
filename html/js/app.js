var maxCount = 0;
var translate = [];
var firstOpen = true;
var tebexLink = "";

$(document).ready(function () {
    window.addEventListener("message", function (event) {
        if (event.data.action === "ui") {
            if (firstOpen) {
                firstOpen = false;
                $.post("https:///pik-multicharacter/started");
            }
            if (event.data.toggle) {
                $(".loadingSection").fadeIn(300);
                maxCount = event.data.defaultCharCount;
                translate = event.data.translate;
                tebexLink = event.data.tebexLink;
                setupArea(maxCount, event.data.mySlotCount);
                setTimeout(() => {
                    $.post("https:///pik-multicharacter/setupCharacters");
                    setTimeout(() => {
                        $(".loadingSection").fadeOut(300);
                    }, 2000);
                }, 2000);
                $(".slotText").html(translate.slot);
                $(".redeemCodeText").html(translate.redeemCode);
                $(".buyCodeButton").html(translate.buyCode);
                $(".agreeText").html(translate.doYouAgreeDelete);
                $(".charInfoText").html(translate.characterInfo);
                $(".loadingText").html(translate.loading);
                $(".pleaseWaitText").html(translate.plsWait);
                $("#redeemCancel").html(translate.cancel);
                $("#redeemAccept").html(translate.accept);
                $("#agreeCancelButton").html(translate.cancel);
                $("#agreeDeleteButton").html(translate.delete);
                $(".titleSvName").html(translate.title);
                $(".chrSelector1").html(translate.character);
                $(".chrSelector2").html(translate.selector);
                $(".leftDescription").html(translate.firstDesc);
                $("#playButton").html(translate.play);
                $("#deleteButton").html(translate.delete);
                $("#dob").html(translate.dateOfBirth);
                $("#natinTE").html(translate.nationality);
                $("#jobTe").html(translate.job);
                $("#cashT").html(translate.cash);
                $("#bankT").html(translate.bank);
                $("#phnNmT").html(translate.phoneNumber);
                $("#accNm").html(translate.accountNumber);
                $(".characterText").html(translate.rightTitle1);
                $(".creatorText").html(translate.rightTitle2);
                $(".creatorDescription").html(translate.rightDescription);
                $("#maleTx").html(translate.male);
                $("#femaleTx").html(translate.female);
                $("#nmTx").html(translate.name);
                $("#srnTx").html(translate.surname);
                $("#ntnTx").html(translate.nationality);
                $("#dobTx").html(translate.dateOfBirth);
                $("#createButtonX").html(translate.create);
            } else {
                $(".loadingSection").hide();
                $(".slotRedeemSection").hide();
                $(".agreeDeleteSection").hide();
                $(".generalSection").hide();
            }
        } else if (event.data.action === "setupCharacters") {
            $(".generalSection").css("display", "flex");
            setupCharacters(event.data.characters);
        } else if(event.data.action === "changingChar"){
            firstOpen = true;
        } else if (event.data.action === "refreshCharacters") {
            setupCharacters(event.data.characters);
        }
    });
});

$(document).on("click", "#createButton", function () {
    var selectedDivId = this;
    if (selectedDivId.id === "createButton") {
        $(".buttonAreas").fadeOut(300);
        var current = document.getElementsByClassName("charItem active");
        if (current.length > 0) {
            current[0].className = current[0].className.replace("charItem active", "charItem");
        }
        var current = document.getElementsByClassName("charItemAgeText active");
        if (current.length > 0) {
            current[0].className = current[0].className.replace("charItemAgeText active", "charItemAgeText");
        }
        var current = document.getElementsByClassName("charItemNameArea active");
        if (current.length > 0) {
            current[0].className = current[0].className.replace("charItemNameArea active", "charItemNameArea");
        }

        var uniqueId = $(selectedDivId).attr("data-uniqueId");
        $("#createButtonX").attr("data-clickedUnique", uniqueId);

        $.post("https:///pik-multicharacter/cDataPed");
        $(".charInfoRight").animate({ left: "30vw" }, 200);
        $(".charCreateRight").animate({ left: "30vw" }, 0);
        setTimeout(() => {
            $(".charInfoRight").hide();
            $(".charCreateRight").show();
            $(".charCreateRight").animate({ left: "0vw" }, 200);
        }, 200);
    }
});

$(document).on("click", ".sexButton", function () {
    var selectedDivId = this;

    var current = document.getElementsByClassName("sexButton active");
    if (current.length > 0) {
        current[0].className = current[0].className.replace("sexButton active", "sexButton");
    }
    var current = document.getElementsByClassName("sexText active");
    if (current.length > 0) {
        current[0].className = current[0].className.replace("sexText active", "sexText");
    }
    nameActiveDiv = selectedDivId.querySelector(".sexText");
    selectedDivId.className += " active";
    nameActiveDiv.className += " active";

    var sex = $(this).attr("data-sex");
    $.post(
        "https:///pik-multicharacter/cDataPed",
        JSON.stringify({
            sex: sex,
        })
    );
    console.log("OK")

});

$(document).on("click", "#locked", function () {
    $(".slotRedeemSection").fadeIn(200);
});

$(document).on("click", "#redeemCancel", function () {
    $(".slotRedeemSection").fadeOut(200);
});

$(document).on("click", "#redeemAccept", function () {
    var input = $(".redeemInput").val();
    if (input) {
        firstOpen = true;
        $.post(
            "https:///pik-multicharacter/sendInput",
            JSON.stringify({
                inputData: input,
            }),
            function (data) {
                if (data) {
                    $(".loadingSection").fadeIn(300);
                    setTimeout(() => {
                        $(".slotRedeemSection").fadeOut(200);
                    }, 300);
                } else {
                    $(".redeemInput").css("border", "1px solid rgba(184, 11, 11, 0.73)");
                    setTimeout(() => {
                        $(".redeemInput").css("border", "1px solid rgba(255, 255, 255, 0.23)");
                    }, 1500);
                }
            }
        );
    }
});

$(document).on("click", ".charItem", function () {
    var selectedDivId = this;
    if (selectedDivId.id === "createButton" || selectedDivId.id === "locked") return;

    $(".buttonAreas").css("opacity", "0");
    $(".buttonAreas").css("display", "flex");
    $(".buttonAreas").animate({ opacity: 1 }, 300);
    var current = document.getElementsByClassName("charItem active");
    if (current.length > 0) {
        current[0].className = current[0].className.replace("charItem active", "charItem");
    }
    var current = document.getElementsByClassName("charItemAgeText active");
    if (current.length > 0) {
        current[0].className = current[0].className.replace("charItemAgeText active", "charItemAgeText");
    }
    var current = document.getElementsByClassName("charItemNameArea active");
    if (current.length > 0) {
        current[0].className = current[0].className.replace("charItemNameArea active", "charItemNameArea");
    }
    ageActiveDiv = selectedDivId.querySelector(".charItemAgeText");
    nameActiveDiv = selectedDivId.querySelector(".charItemNameArea");
    iconDiv = selectedDivId.querySelector("#sexIconActive");
    selectedDivId.className += " active";
    ageActiveDiv.className += " active";
    nameActiveDiv.className += " active";

    var stringInfo = $(selectedDivId).attr("data-itemInfo");
    var parseInfo = JSON.parse(stringInfo);
    var charInfoParse = parseInfo.charinfo;
    var jobInfoParse = parseInfo.job;
    var moneyInfoParse = parseInfo.money;
    $(".rightSexText").removeClass("male");
    $(".rightSexText").removeClass("female");
    var charSex = charInfoParse.gender == 0 ? "male" : "female";
    var sexLabel = charSex == "male" ? translate.male : translate.female;
    $(".rightSexText").addClass(charSex);
    $(".rightSexText").html(sexLabel);
    $(".rightCharName").html(`${charInfoParse.firstname} ${charInfoParse.lastname}`);
    $("#dateInfo").html(charInfoParse.birthdate);
    $("#natinInfo").html(charInfoParse.nationality);
    $("#jobInfo").html(jobInfoParse.label);
    $("#cashInfo").html("$" + moneyInfoParse.cash);
    $("#bankInfo").html("$" + moneyInfoParse.bank);
    $("#phoneInfo").html(charInfoParse.phone);
    $("#citizenIdInfo").html(charInfoParse.account);
    $(".charCreateRight").animate({ left: "30vw" }, 200);
    $(".charInfoRight").animate({ left: "30vw" }, 200);
    $("#clickablePlay").attr("data-cid", parseInfo.citizenid);
    $("#agreeDeleteButton").attr("data-charInfo", stringInfo);
    $(".charNameAgreeText").html(charInfoParse.firstname + " " + charInfoParse.lastname);
    $.post(
        "https:///pik-multicharacter/cDataPed",
        JSON.stringify({
            cData: parseInfo.citizenid,
        })
    );
    console.log("OK")

    setTimeout(() => {
        $(".charInfoRight").show();
        $(".charCreateRight").hide();
        $(".charInfoRight").animate({ left: "0vw" }, 200);
    }, 200);
});

$(document).on("click", "#clickablePlay", function () {
    var selectedDivId = this;
    var cid = $(selectedDivId).attr("data-cid");

    $.post(
        "https:///pik-multicharacter/selectCharacter",
        JSON.stringify({
            cData: cid,
        })
    );
});

$(document).on("click", "#clickableDelete", function () {
    var selectedDivId = this;
    $(".agreeDeleteSection").fadeIn(100);
});

$(document).on("click", "#agreeCancelButton", function () {
    var selectedDivId = this;
    $(".agreeDeleteSection").fadeOut(100);
});

$(document).on("click", "#agreeDeleteButton", function () {
    var selectedDiv = this;
    var stringInfo = $("#agreeDeleteButton").attr("data-charInfo");
    var parseInfo = JSON.parse(stringInfo);
    $(".loadingSection").fadeIn(300);
    firstOpen = true;
    $.post(
        "https:///pik-multicharacter/removeCharacter",
        JSON.stringify({
            citizenid: parseInfo.citizenid,
        })
    );
    $(".agreeDeleteSection").fadeOut(100);
    $.post("https:///pik-multicharacter/refreshCharacters");
    setTimeout(() => {

    }, 1000);
    $(".agreeDeleteSection").fadeOut(100);
});

function setupArea(maxCount, myCount) {
    $(".charListLeftArea").empty();
    $(".charListRightArea").empty();
    for (let index = 0; index < maxCount; index++) {
        var bottomRect = index + 1 != maxCount ? '<div class="bottomRectangle"></div>' : "";
        $(".charListLeftArea").append(`
            <div class="rectangleItem" data-rectUniqueId="${index + 1}">
                <div class="leftText empty">${index + 1}</div>
                <div class="rightRectangle"></div>
                ${bottomRect}
            </div>
        `);
        if (index + 1 <= myCount) {
            $(".charListRightArea").append(`
                <div class="charItem create" id="createButton" data-uniqueId="${index + 1}">
                    <div class="charCreateImgArea">
                        <img src="./images/create.png" alt="" />
                    </div>
                    <div class="createCharText">${translate.createCharacter}</div>
                </div>
            `);
        } else {
            $(".charListRightArea").append(`
                <div class="charItem locked" id="locked" data-uniqueId="${index + 1}">
                    <div class="charCreateImgArea">
                        <img src="./images/lock.png" alt="" />
                    </div>
                </div>
            `);
        }
    }
}

function setupCharacters(charsData) {
    if (charsData.length > 0) {
        charsData.forEach((element, index) => {
            var myItemDom = document.querySelectorAll(`[data-uniqueId="${index + 1}"]`);
            var myRectDom = document.querySelectorAll(`[data-rectUniqueId="${index + 1}"]`);
            var bottomRect = index + 1 != maxCount ? '<div class="bottomRectangle"></div>' : "";
            var jsonData = element.charinfo;
            var charSex = jsonData.gender == 0 ? "male" : "female";
            var sexLabel = charSex == "male" ? translate.male : translate.female;
            myItemDom[0].classList.remove("create");
            myItemDom[0].id = "char";
            $(myItemDom).attr("data-itemInfo", JSON.stringify(element));
            $(myRectDom).html(`
                <div class="leftText">${index + 1}</div>
                <div class="rightRectangle"></div>
                ${bottomRect}
            `);
            $(myItemDom).html(`
                <div class="charItemSexArea ${charSex}">${sexLabel}</div>
                <div class="charItemAgeText">
                    <span class="age">${element.citizenid}</span>
                </div>
                <div class="charItemNameArea">
                    <span class="firstName">${jsonData.firstname}</span>
                    <span class="lastName">${jsonData.lastname}</span>
                </div>
                <div class="charItemArrowArea">
                    <img src="./images/arrow.png" alt="" />
                </div>
            `);
        });
    }
    $(".charItem:first-child").click();
}

var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;",
    "/": "&#x2F;",
    "": "&#x60;",
    "=": "&#x3D;",
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'=/]/g, function (s) {
        return entityMap[s];
    });
}
function hasWhiteSpace(s) {
    return /\s/g.test(s);
}

$(document).on("click", "#createButtonX", function () {
    var selectedDivId = this;
    let firstname = escapeHtml($("#firstname").val());
    let lastname = escapeHtml($("#lastname").val());
    let nationality = escapeHtml($("#nationality").val());
    let birthdate = escapeHtml($("#datepicker").val());
    var current = document.getElementsByClassName("sexButton active");
    let gender = "male";
    if (current.length > 0) {
        gender = $(current).attr("data-sex");
    }
    let cid = escapeHtml($(this).attr("data-clickedUnique"));
    const regTest = new RegExp(profList.join("|"), "i");
    if (!firstname || !lastname || !nationality || !birthdate || hasWhiteSpace(firstname) || hasWhiteSpace(lastname) || hasWhiteSpace(nationality)) {
        console.log("FIELDS REQUIRED");
        return false;
    }
    if (regTest.test(firstname) || regTest.test(lastname)) {
        console.log("ERROR: You used a derogatory/vulgar term. Please try again!");
        return false;
    }

    $.post(
        "https:///pik-multicharacter/createNewCharacter",
        JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            nationality: nationality,
            birthdate: birthdate,
            gender: gender,
            cid: cid,
        })
    );
    setTimeout(() => {
        $(".loadingSection").fadeOut(150);
        $(".slotRedeemSection").fadeOut(150);
        $(".agreeDeleteSection").fadeOut(150);
        $(".generalSection").fadeOut(150);
    }, 200);
});

$(document).on("click", "#buyCodeButton", function () {
    window.invokeNative("openUrl", tebexLink);
});
