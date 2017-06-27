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

package eu.operando.proxy.settings;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.content.res.Resources;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;

import eu.operando.R;
import eu.operando.proxy.MainContext;


//TODO: Utilize this ?
class Repository {
    private Context context;
    private Resources resources;

    protected void initializeDefaultValues() {
        PreferenceManager.setDefaultValues(getContext(), R.xml.preferences, false);
    }

    protected void registerOnSharedPreferenceChangeListener(OnSharedPreferenceChangeListener onSharedPreferenceChangeListener) {
        getSharedPreferences().registerOnSharedPreferenceChangeListener(onSharedPreferenceChangeListener);
    }

    protected void save(int key, int value) {
        save(getContext().getString(key), "" + value);
    }

    private void save(String key, String value) {
        SharedPreferences.Editor editor = getSharedPreferences().edit();
        editor.putString(key, value);
        editor.apply();
    }

    protected int getStringAsInteger(int key, int defaultValue) {
        try {
            return Integer.parseInt(getString(key, "" + defaultValue));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    protected String getString(int key, String defaultValue) {
        String keyValue = getContext().getString(key);
        try {
            return getSharedPreferences().getString(keyValue, defaultValue);
        } catch (Exception e) {
            save(keyValue, defaultValue);
            return defaultValue;
        }
    }

    protected int getResourceInteger(int key) {
        return getResources().getInteger(key);
    }

    protected int getInteger(int key, int defaultValue) {
        String keyValue = getContext().getString(key);
        try {
            return getSharedPreferences().getInt(keyValue, defaultValue);
        } catch (Exception e) {
            save(keyValue, "" + defaultValue);
            return defaultValue;
        }
    }

    private SharedPreferences getSharedPreferences() {
        return PreferenceManager.getDefaultSharedPreferences(getContext());
    }

    // injectors start
    private Context getContext() {
        if (context == null) {
            context = MainContext.INSTANCE.getContext();
        }
        return context;
    }

    protected void setContext(@NonNull Context context) {
        this.context = context;
    }

    private Resources getResources() {
        if (resources == null) {
            resources = MainContext.INSTANCE.getResources();
        }
        return resources;
    }

    protected void setResources(@NonNull Resources resources) {
        this.resources = resources;
    }
    // injectors end
}
