var labels = ["Email","E-mail","Email address","E-mail address"];

var DOMElement = function (element, executeJobWhenEmail) {
    if (!(element instanceof HTMLElement)) {
        throw "Element is not a jQuery object";
    }
    else {
        this.element = element;
        this.isLoginField = false;
        this.isRegisterField = false;

        if(executeJobWhenEmail){
            this.whenEmailCompleted = executeJobWhenEmail;
        }
        else{
            this.whenEmailCompleted = false;
        }
    }
};

DOMElement.prototype = {
    isInLoginForm: function () {
        return this.isLoginField;
    },
    isInRegisterForm: function () {
        return this.isRegisterField;
    },
    setAsLoginField: function () {
        this.isLoginField = true;
    },
    setAsRegisterField: function () {
        this.isRegisterField = true;
    },
    executeJob:function(task){
        task(this.element, this.whenEmailCompleted);
    }
};


var ElementsPool = function(){
    this.inputElements = [];
};

ElementsPool.prototype = {


    addJob : function(task){
        this.task = task;
    },

    addSelector: function (selector) {
        var self = this;
        var scanInterval = null;

        var scanDocument = function () {
            jQuery(selector).each(function (index, element) {
                 self.addInputElement(element);
            });
        };

        function handleVisibilityChange() {
            if (document.hidden) {
                if (scanInterval) {
                    clearInterval(scanInterval);
                }
            } else {
                scanInterval = setInterval(scanDocument, 1000);
            }
        }

        document.addEventListener("visibilitychange", handleVisibilityChange, false);
        handleVisibilityChange();
        setTimeout(scanDocument, 100);
    },

    searchTextInputSelector: function (selector) {
        var self = this;
        var scanInterval = null;

        var scanDocument = function () {
            jQuery(selector).each(function (index, element) {

                if (element.hasAttribute("type") && element.getAttribute("type") == "text") {
                    var prev = $(element).prev("label")[0];
                    if (prev && labels.indexOf($(prev).text()) >= 0) {
                        self.addInputElement(element);
                    } else {
                        self.addInputElement(element, true);
                    }
                }
            });
        };

        function handleVisibilityChange() {
            if (document.hidden) {
                if (scanInterval) {
                    clearInterval(scanInterval);
                }
            } else {
                scanInterval = setInterval(scanDocument, 1000);
            }
        }
        document.addEventListener("visibilitychange", handleVisibilityChange, false);
        handleVisibilityChange();
        setTimeout(scanDocument, 100);
    },
    addInputElement: function (el, checkForEmail) {
        var self = this;
        var htmlElementAlreadyExists = false;
        this.inputElements.forEach(function (inputElement) {
            if (inputElement.element === el) {
                htmlElementAlreadyExists = true;
            }
        });

        if (!htmlElementAlreadyExists) {
            var newElement = new DOMElement(el, checkForEmail);
            newElement.executeJob(self.task);
            this.inputElements.push(newElement);
        }
    },

    removeInputElement: function (el) {
        for (var i = 0; i <= this.inputElements.length; i++) {
            if (this.inputElements[i] === el) {
                this.inputElements.splice(i, 1);
            }
        }
    },

    setFieldTasks: function (taskFn) {
    }
};

var ElementsProvider = (function(){
    var instance;
    return {
        getInstance:function(){
            if(!instance){
                instance = new ElementsPool();
            }
            return instance;
        }
    }
})();




