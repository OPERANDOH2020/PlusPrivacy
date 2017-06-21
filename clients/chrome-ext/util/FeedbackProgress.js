/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var FeedbackProgress = {
    isVisible:false,
    feedbackContainer:null,
    feedbackMessage:null,
    animation:null,
    innerContainer:null,

    initFeedback:function(){

        this.isVisible = true;
        this.feedbackContainer = document.getElementById("operando_feedback_container");


        if (this.feedbackContainer == null) {
            this.feedbackContainer = document.createElement("div");
            this.feedbackContainer.id = "operando_feedback_container";

            this.innerContainer = document.createElement("div");
            this.innerContainer.id = "operando_feedback_inner_container";
            this.feedbackContainer.appendChild(this.innerContainer);

            this.feedbackMessage = document.createElement("div");
            this.feedbackMessage.id = "operando_feedback_message";
            this.innerContainer.appendChild(this.feedbackMessage);
            document.body.appendChild(this.feedbackContainer);

            this.loadAnimation();
        }

    },

    sendFeedback: function (message, index, total) {

        if(this.isVisible == false){
            this.initFeedback();
        }

        var feedbackMessage = document.getElementById("operando_feedback_message");
        var messageElement = document.createTextNode(message);
        feedbackMessage.innerHTML = '';
        feedbackMessage.appendChild(messageElement);
        var procentElement = document.createElement("div");
        procentElement.id = "operando_feedback_procent";
        procentElement.innerHTML = Math.floor(index * 100 / total) + "%";
        feedbackMessage.appendChild(procentElement);
    },

    clearFeedback: function (message) {
        var self = this;

        if (this.feedbackContainer != null) {
            if (this.feedbackMessage != null) {
                this.feedbackMessage.innerHTML = message;
            }

            self.removeAnimation();
            setTimeout(function () {
                document.body.removeChild(self.feedbackContainer);
                this.isVisible = false;
            }, 2000);
        }
    },

    loadAnimation:function(){
        this.animation = document.createElement("div");
        this.animation.className="operando_animation";
        this.animation.innerHTML='<div class="spinner"><div class="animation-double-bounce1"></div><div class="animation-double-bounce2"></div></div>';
        this.innerContainer.appendChild(this.animation);
    },
    removeAnimation:function(){
        this.innerContainer.removeChild(this.animation);
    }
}


