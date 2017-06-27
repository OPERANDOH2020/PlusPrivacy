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
import android.support.annotation.NonNull;

import eu.operando.R;
import eu.operando.proxy.wifi.band.WiFiBand;
import eu.operando.proxy.wifi.model.GroupBy;
import eu.operando.proxy.wifi.model.SortBy;

import static android.content.SharedPreferences.OnSharedPreferenceChangeListener;

public class Settings {
    private final Context context;
    private Repository repository;

    public Settings(@NonNull Context context) {
        this.context = context;
        setRepository(new Repository());
    }

    public void setRepository(@NonNull Repository repository) {
        this.repository = repository;
    }

    public void initializeDefaultValues() {
        repository.initializeDefaultValues();
    }

    public void registerOnSharedPreferenceChangeListener(OnSharedPreferenceChangeListener onSharedPreferenceChangeListener) {
        repository.registerOnSharedPreferenceChangeListener(onSharedPreferenceChangeListener);
    }

    public int getScanInterval() {

        return repository.getInteger(R.string.scan_interval_key, repository.getResourceInteger(R.integer.scan_interval_default));
    }

    public SortBy getSortBy() {
        return SortBy.find(repository.getStringAsInteger(R.string.sort_by_key, SortBy.STRENGTH.ordinal()));
    }

    public GroupBy getGroupBy() {
        return GroupBy.find(repository.getStringAsInteger(R.string.group_by_key, GroupBy.NONE.ordinal()));
    }


    public WiFiBand getWiFiBand() {
        return WiFiBand.find(repository.getStringAsInteger(R.string.wifi_band_key, WiFiBand.GHZ2.ordinal()));
    }

    public ThemeStyle getThemeStyle() {
        return ThemeStyle.find(repository.getStringAsInteger(R.string.theme_key, ThemeStyle.DARK.ordinal()));
    }

    public void toggleWiFiBand() {
        repository.save(R.string.wifi_band_key, getWiFiBand().toggle().ordinal());
    }

}
