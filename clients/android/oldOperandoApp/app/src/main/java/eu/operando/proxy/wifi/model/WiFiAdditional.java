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
import org.apache.commons.lang3.builder.ToStringBuilder;

import be.shouldit.proxy.lib.APL;
import be.shouldit.proxy.lib.WiFiApConfig;

public class WiFiAdditional {
    public static final WiFiAdditional EMPTY = new WiFiAdditional(StringUtils.EMPTY, false, null);

    private final String vendorName;
    private final String ipAddress;
    private final int linkSpeed;
    private final boolean configuredNetwork;

    //TODO: patpatza
    private WiFiApConfig wiFiApConfig;

    private WiFiAdditional(@NonNull String vendorName, @NonNull String ipAddress, int linkSpeed, boolean configuredNetwork) {
        this.vendorName = vendorName;
        this.ipAddress = ipAddress;
        this.configuredNetwork = configuredNetwork;
        this.linkSpeed = linkSpeed;
    }

    public WiFiAdditional(@NonNull String vendorName, @NonNull String ipAddress, int linkSpeed, WifiConfiguration wifiConfiguration) {
        this(vendorName, ipAddress, linkSpeed, true);
        this.wiFiApConfig = APL.getWiFiAPConfiguration(wifiConfiguration);
    }

    public WiFiAdditional(@NonNull String vendorName, boolean configuredNetwork, WifiConfiguration wifiConfiguration) {
        this(vendorName, StringUtils.EMPTY, WiFiConnection.LINK_SPEED_INVALID, configuredNetwork);
        this.wiFiApConfig = APL.getWiFiAPConfiguration(wifiConfiguration);
    }

    public String getVendorName() {
        return vendorName;
    }

    public String getIPAddress() {
        return ipAddress;
    }

    public int getLinkSpeed() {
        return linkSpeed;
    }

    public WiFiApConfig getWiFiApConfig() {
        return wiFiApConfig;
    }

    public boolean isConnected() {
        return StringUtils.isNotBlank(getIPAddress());
    }

    public boolean isConfiguredNetwork() {
        return configuredNetwork;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}