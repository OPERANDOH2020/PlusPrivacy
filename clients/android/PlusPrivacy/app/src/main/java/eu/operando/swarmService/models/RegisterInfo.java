package eu.operando.swarmService.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Matei_Alexandru on 09.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class RegisterInfo {
    private String username;
    private String email;
    private String password;
    @SerializedName("repeat_password")
    private String repeatPassword;

    public RegisterInfo(String email, String password, String repeatPassword) {
        this.email = email;
        this.password = password;
        this.repeatPassword = repeatPassword;
    }
}
