package eu.operando.models.privacysettings;

import java.util.List;

/**
 * Created by Matei_Alexandru on 06.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookSettings {
    private List<Preference> facebook;

    public List<Preference> getFacebook() {
        return facebook;
    }

    public void setFacebook(List<Preference> facebook) {
        this.facebook = facebook;
    }

    public FacebookSettings(List<Preference> facebook) {

        this.facebook = facebook;
    }

    public void add(Preference setting){
        facebook.add(setting);
    }
}
