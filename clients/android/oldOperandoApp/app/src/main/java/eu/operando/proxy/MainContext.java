/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;

import com.squareup.otto.Bus;

import eu.operando.proxy.database.DatabaseHelper;
import eu.operando.proxy.settings.Settings;
import eu.operando.proxy.util.NotificationUtil;
import eu.operando.proxy.wifi.scanner.Scanner;
import mitm.Authority;


public enum MainContext {
    INSTANCE;

    private Settings settings;
    private Context context;
    private Resources resources;
    private Scanner scanner;
    private LayoutInflater layoutInflater;
    private NotificationUtil notificationUtil;
    private Authority authority;
    private SharedPreferences sharedPreferences;
    private DatabaseHelper databaseHelper;
    private Bus BUS;

    public Bus getBUS() {
        return BUS;
    }

    public void setBUS(@NonNull Bus BUS) {
        this.BUS = BUS;
    }

    public SharedPreferences getSharedPreferences() {
        return sharedPreferences;
    }

    public void setSharedPreferences(@NonNull SharedPreferences sharedPreferences) {
        this.sharedPreferences = sharedPreferences;
    }

    public DatabaseHelper getDatabaseHelper() {
        return databaseHelper;
    }

    public void setDatabaseHelper(@NonNull DatabaseHelper databaseHelper) {
        this.databaseHelper = databaseHelper;
    }

    public Authority getAuthority() {
        return authority;
    }

    public void setAuthority(@NonNull Authority authority) {
        this.authority = authority;
    }

    public Settings getSettings() {
        return settings;
    }

    public void setSettings(@NonNull Settings settings) {
        this.settings = settings;
    }

    public Scanner getScanner() {
        return scanner;
    }

    public void setScanner(@NonNull Scanner scanner) {
        this.scanner = scanner;
    }

    public NotificationUtil getNotificationUtil() {
        return notificationUtil;
    }

    public void setNotificationUtil(@NonNull NotificationUtil notificationUtil) {
        this.notificationUtil = notificationUtil;
    }

    public LayoutInflater getLayoutInflater() {
        return layoutInflater;
    }

    public void setLayoutInflater(LayoutInflater layoutInflater) {
        this.layoutInflater = layoutInflater;
    }

    public Resources getResources() {
        return resources;
    }

    public void setResources(Resources resources) {
        this.resources = resources;
    }

    public Context getContext() {
        return context;
    }

    public void setContext(@NonNull Context context) {
        this.context = context;
    }


}
