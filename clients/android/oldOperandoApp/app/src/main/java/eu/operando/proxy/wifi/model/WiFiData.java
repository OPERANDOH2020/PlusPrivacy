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

package eu.operando.proxy.wifi.model;

import android.net.wifi.WifiConfiguration;
import android.support.annotation.NonNull;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import eu.operando.proxy.wifi.band.WiFiBand;


public class WiFiData {
    private final List<WiFiDetail> wiFiDetails;
    private final WiFiConnection wiFiConnection;
    List<WifiConfiguration> configuredNetworks;

    public List<WifiConfiguration> getConfiguredNetworks() {
        return configuredNetworks;
    }

    public WiFiData(@NonNull List<WiFiDetail> wiFiDetails, @NonNull WiFiConnection wiFiConnection, @NonNull List<WifiConfiguration> configuredNetworks) {
        this.wiFiDetails = wiFiDetails;
        this.wiFiConnection = wiFiConnection;
        this.configuredNetworks = configuredNetworks;
    }

    @NonNull
    public WiFiDetail getConnection() {
        for (WiFiDetail wiFiDetail : wiFiDetails) {
            if (wiFiConnection.equals(new WiFiConnection(wiFiDetail.getSSID(), wiFiDetail.getBSSID()))) {
                String vendorName = StringUtils.EMPTY;
                WifiConfiguration wifiConfiguration = getConfigurationForWiFiDetail(wiFiDetail);

                WiFiAdditional wiFiAdditional = new WiFiAdditional(vendorName, wiFiConnection.getIpAddress(), wiFiConnection.getLinkSpeed(), wifiConfiguration);
                return new WiFiDetail(wiFiDetail, wiFiAdditional);
            }
        }
        return WiFiDetail.EMPTY;
    }

    @NonNull
    public List<WiFiDetail> getWiFiDetails(@NonNull WiFiBand wiFiBand, @NonNull SortBy sortBy) {
        return getWiFiDetails(wiFiBand, sortBy, GroupBy.NONE);
    }

    @NonNull
    public List<WiFiDetail> getWiFiDetails(@NonNull WiFiBand wiFiBand, @NonNull SortBy sortBy, @NonNull GroupBy groupBy) {
        List<WiFiDetail> results = getWiFiDetails(wiFiBand);
        if (!results.isEmpty() && !GroupBy.NONE.equals(groupBy)) {
            results = getWiFiDetails(results, sortBy, groupBy);
        }
        Collections.sort(results, sortBy.comparator());
        return Collections.unmodifiableList(results);
    }

    @NonNull
    protected List<WiFiDetail> getWiFiDetails(@NonNull List<WiFiDetail> wiFiDetails, @NonNull SortBy sortBy, @NonNull GroupBy groupBy) {
        List<WiFiDetail> results = new ArrayList<>();
        Collections.sort(wiFiDetails, groupBy.sortOrder());
        WiFiDetail parent = null;
        for (WiFiDetail wiFiDetail : wiFiDetails) {
            if (parent == null || groupBy.groupBy().compare(parent, wiFiDetail) != 0) {
                if (parent != null) {
                    Collections.sort(parent.getChildren(), sortBy.comparator());
                }
                parent = wiFiDetail;
                results.add(parent);
            } else {
                parent.addChild(wiFiDetail);
            }
        }
        if (parent != null) {
            Collections.sort(parent.getChildren(), sortBy.comparator());
        }
        Collections.sort(results, sortBy.comparator());
        return results;
    }


    @NonNull
    private List<WiFiDetail> getWiFiDetails(@NonNull WiFiBand wiFiBand) {
        List<WiFiDetail> results = new ArrayList<>();
        WiFiDetail connection = getConnection();
        for (WiFiDetail wiFiDetail : wiFiDetails) {
            if (wiFiDetail.getWiFiSignal().getWiFiBand().equals(wiFiBand)) {
                if (wiFiDetail.equals(connection)) {
                    results.add(connection);
                } else {
                    String vendorName = StringUtils.EMPTY;
                    //TODO: make this more elegant
                    WifiConfiguration wifiConfiguration = getConfigurationForWiFiDetail(wiFiDetail);
                    WiFiAdditional wiFiAdditional = new WiFiAdditional(vendorName, (wifiConfiguration != null), wifiConfiguration);
                    results.add(new WiFiDetail(wiFiDetail, wiFiAdditional));
                }
            }
        }
        return results;
    }


    private WifiConfiguration getConfigurationForWiFiDetail(WiFiDetail wiFiDetail) {
        for (WifiConfiguration configuration : configuredNetworks) {
            if (WiFiUtils.convertSSID(configuration.SSID).equals(wiFiDetail.getSSID()) && !((configuration.BSSID != null && !configuration.BSSID.equals("any")) && configuration.BSSID.equals(wiFiDetail.getBSSID()))) {
                return configuration;
            }
        }
        return null;
    }


    @NonNull
    public List<WiFiDetail> getWiFiDetails() {
        return Collections.unmodifiableList(wiFiDetails);
    }

    @NonNull
    public WiFiConnection getWiFiConnection() {
        return wiFiConnection;
    }

}
