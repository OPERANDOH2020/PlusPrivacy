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

package eu.operando.proxy.wifi;

import android.support.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

import eu.operando.proxy.MainContext;
import eu.operando.proxy.settings.Settings;
import eu.operando.proxy.wifi.model.WiFiData;
import eu.operando.proxy.wifi.model.WiFiDetail;


class AccessPointsAdapterData {
    private List<WiFiDetail> wiFiDetails = new ArrayList<>();
    private Settings settings;

    protected void update(WiFiData wiFiData) {
        Settings settings = getSettings();
        wiFiDetails = wiFiData.getWiFiDetails(settings.getWiFiBand(), settings.getSortBy(), settings.getGroupBy());
    }

    protected int parentsCount() {
        return wiFiDetails.size();
    }

    private boolean validParentIndex(int index) {
        return index >= 0 && index < parentsCount();
    }

    private boolean validChildrenIndex(int indexParent, int indexChild) {
        return validParentIndex(indexParent) && indexChild >= 0 && indexChild < childrenCount(indexParent);
    }

    protected WiFiDetail parent(int index) {
        return validParentIndex(index) ? wiFiDetails.get(index) : WiFiDetail.EMPTY;
    }

    protected int childrenCount(int index) {
        return validParentIndex(index) ? wiFiDetails.get(index).getChildren().size() : 0;
    }

    protected WiFiDetail child(int indexParent, int indexChild) {
        return validChildrenIndex(indexParent, indexChild) ? wiFiDetails.get(indexParent).getChildren().get(indexChild) : WiFiDetail.EMPTY;
    }

    // injectors start
    private Settings getSettings() {
        if (settings == null) {
            settings = MainContext.INSTANCE.getSettings();
        }
        return settings;
    }

    protected void setSettings(@NonNull Settings settings) {
        this.settings = settings;
    }
    // injectors end

}
