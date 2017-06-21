var port = chrome.runtime.connect({name: "INPUT_TRACKER"});
var Preferences = UserPreferences.getInstance();
var myIdentities = [];
var myRealIdentity = null;
var elementsProvider = ElementsProvider.getInstance();

port.onMessage.addListener(function (response) {
    myIdentities = response.message.data;
    myRealIdentity = myIdentities.find(function (identity) {
        return identity.isReal;
    });
    if(myRealIdentity == undefined){
        myRealIdentity = myIdentities[0];
    }

});

function sendMessage(message) {
    port.postMessage(message);
}

var tooltipTemplate = "<div class='pp_identity_popup'>"
    + "<div class='pp-popup-header'>Would you like to use a substitute identity?</div><br/>"
    + "<select class='pp_select' id='pp_identities'>"
    + "</select>"
    + "<button id='accept_identity_substitution' class='pp_button'>Yes</button>"
    + "<button id='deny_identity_substitution' class='pp_button'>No</button>"
    + "</div>";


function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (myRealIdentity === null || myRealIdentity == undefined) {
        return re.test(email);
    }
    else {
        return email === myRealIdentity.email;
    }
}

function getMyIdentities() {
    sendMessage({action: "listIdentities"});
}

getMyIdentities();

function denySubstituteIdentity(element) {
    Preferences.addPreference("websitePreferences", {url: window.location.hostname, accept: false});
}

Preferences.getPreferences("websitePreferences", {
    url: window.location.hostname,
    accept: false
}, function (preferences) {
    if (Object.keys(preferences).length === 0) {
        elementsProvider.addJob(checkElement);
        elementsProvider.addSelector("input[type=email], input[name=email], input[id=user_login]");
        elementsProvider.searchTextInputSelector("input[type=text]");
    }
});


var checkElement = function (element, whenEmailCompleted) {
    (function (element) {
        element.on("sleepAll", function () {
            element.off("keyup paste focus", checkIfEmailIsValid);
            element.off("blur", handleTooltipsOnBlur);
        });

        var checkIfEmailIsValid = function () {
            if ($(element).is(":focus")) {
                if (whenEmailCompleted == false || validateEmail(element.val())) {
                    element
                        .tooltipster({
                            contentAsHTML: true,
                            content: jQuery(jQuery.parseHTML(tooltipTemplate)),
                            theme: ['tooltipster-plus-privacy'],
                            trigger: "custom",
                            interactive: true,
                            animationDuration: 200,
                            zIndex: 2147483647,
                            functionInit: function (instance, helper) {

                                var content = instance.content();
                                var identities = myIdentities;

                                var identitiesSelect = content.find("select")[0];
                                identities.forEach(function (identity) {
                                    var opt = document.createElement('option');
                                    opt.value = identity.email;
                                    opt.innerHTML = identity.email;
                                    if (identity.isDefault === true) {
                                        opt.setAttribute("selected", "selected");
                                    }
                                    identitiesSelect.appendChild(opt);
                                });

                                $(identitiesSelect).on("click", function () {
                                    element.tooltipster('open');
                                });

                                $(content).on("click", function (event) {
                                    event.stopPropagation();
                                });

                                instance.content(content);

                            },
                            functionReady: function () {
                                $("#accept_identity_substitution").on("click", function () {
                                    element.val($("#pp_identities").val());
                                    element.tooltipster('close');
                                    element.hasTooltip = false;
                                });
                                $("#deny_identity_substitution").on("click", function () {
                                    denySubstituteIdentity(element);
                                    element.tooltipster('close');
                                    element.hasTooltip = false;
                                    element.trigger("sleepAll");
                                });
                            }
                        })
                        .tooltipster('open');

                    element.hasTooltip = true;
                } else {
                    if (element.hasTooltip === true) {
                        element.tooltipster('close');
                        element.hasTooltip = false;
                    }
                }
            }
        };

        var handleTooltipsOnBlur = function (event) {
            if (element.hasTooltip) {
                element.tooltipster('close');
                element.hasTooltip = false;
            }
        };

        element.on("keyup paste focus", checkIfEmailIsValid);
        element.on("blur", handleTooltipsOnBlur);
        checkIfEmailIsValid();
    })($(element))
}

