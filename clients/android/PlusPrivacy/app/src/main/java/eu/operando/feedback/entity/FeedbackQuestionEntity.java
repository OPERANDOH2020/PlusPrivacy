package eu.operando.feedback.entity;

import java.util.List;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */


/*
{
    "feedbackQuestions": [{
        "title": "How useful are the features of {+P} in protecting your privacy?",
        "type": "multipleRating",
        "description": "1 - not useful; 5 - very useful",
        "required": true,
        "range": ["1", "2", "3", "4", "5"],
        "items": ["Social networks privacy settings", "Extensions & apps", "Ad blocking and anti-tracking", "Alternative email identities", "Mobile apps", "Single Click Privacy"]
    }, {
        "title": "How useful are the unified settings of social networks in {+P}?",
        "type": "multipleRating",
        "description": "1 - not useful; 5 - very useful",
        "required": true,
        "range": ["1", "2", "3", "4", "5"],
        "items": ["Facebook", "Linkedin", "Twitter"]
    }, {
        "title": "Settings of which other social networks should be included?",
        "type": "multipleSelection",
        "required": false,
        "items": ["Pinterest", "Xing", "Reddit", "Tumblr", "Google+", "Instagram", "Youtube", "VKontakte"]
    }, {
        "title": "Additional feedback on social network privacy features",
        "type": "textInput",
        "required": false
    }, {
        "title": "Additional feedback on Extensions & Apps feature",
        "type": "textInput",
        "required": false
    }, {
        "title": "Additional feedback on Alternative Email Identities feature",
        "type": "textInput",
        "required": false
    }, {
        "title": "Would you trade some of your privacy for an economic benefit, such as price discount?",
        "type": "radio",
        "required": true,
        "items": ["Yes", "No", "Depends on the benefit"]
    }, {
        "title": "Additional feedback on {+P} mobile apps",
        "type": "textInput",
        "required": false
    }, {
        "title": "Any other feedback?",
        "type": "textInput",
        "required": false
    }]
}
 */
public class FeedbackQuestionEntity {

    private Object response;

    private String title;
    private String type;
    private String description;
    private boolean required;
    private List<String> range;
    private List<String> items;

    public FeedbackQuestionEntity(String title, String type, String description, boolean required, List<String> range, List<String> items) {
        this.title = title;
        this.type = type;
        this.description = description;
        this.required = required;
        this.range = range;
        this.items = items;
    }

    public Object getResponse() {
        return response;
    }

    public void setResponse(Object response) {
        this.response = response;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }

    public List<String> getRange() {
        return range;
    }

    public void setRange(List<String> range) {
        this.range = range;
    }

    public List<String> getItems() {
        return items;
    }

    public void setItems(List<String> items) {
        this.items = items;
    }


    @Override
    public String toString() {
        return "FeedbackQuestionEntity{" +
                "response=" + response +
                ", title='" + title + '\'' +
                ", type='" + type + '\'' +
                ", description='" + description + '\'' +
                ", required=" + required +
                ", range=" + range +
                ", items=" + items +
                '}';
    }
}


