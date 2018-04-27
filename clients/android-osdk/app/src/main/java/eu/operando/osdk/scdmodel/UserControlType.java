package eu.operando.osdk.scdmodel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public enum UserControlType {

    C1("ControlViaSystemWindowRawValue "),
    C2("ControlViaApplicationWindowRawValue"),
    C3("NoControlRawValue");

    private String userControl;

    UserControlType(String userControl) {
        this.userControl = userControl;
    }

    public String getUserControl() {
        return userControl;
    }
}
