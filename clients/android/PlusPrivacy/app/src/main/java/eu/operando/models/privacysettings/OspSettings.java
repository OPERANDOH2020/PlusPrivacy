package eu.operando.models.privacysettings;

import java.util.List;

/**
 * Created by Matei_Alexandru on 01.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OspSettings {

    private List<Question> facebook;
    private List<Question> linkedin;
    private List<Question> twitter;
    private List<Question> google;

    public OspSettings(List<Question> facebook, List<Question> linkedin, List<Question> twitter,
                       List<Question> google) {
        this.facebook = facebook;
        this.linkedin = linkedin;
        this.twitter = twitter;
        this.google = google;
    }

    public List<Question> getFacebook() {
        return facebook;
    }

    public void setFacebook(List<Question> facebook) {
        this.facebook = facebook;
    }

    public List<Question> getLinkedin() {
        return linkedin;
    }

    public void setLinkedin(List<Question> linkedin) {
        this.linkedin = linkedin;
    }

    public List<Question> getTwitter() {
        return twitter;
    }

    public void setTwitter(List<Question> twitter) {
        this.twitter = twitter;
    }

    public List<Question> getGoogle() {
        return google;
    }

    public void setGoogle(List<Question> google) {
        this.google = google;
    }

    @Override
    public String toString() {
        return "OspSettings{" +
                "facebook=" + facebook +
                ", linkedin=" + linkedin +
                ", twitter=" + twitter +
                ", google=" + google +
                '}';
    }
}
