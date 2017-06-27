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

import android.support.annotation.NonNull;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.CompareToBuilder;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.ArrayList;
import java.util.List;

public class WiFiDetail implements Comparable<WiFiDetail> {
    public static final WiFiDetail EMPTY = new WiFiDetail(StringUtils.EMPTY, StringUtils.EMPTY, StringUtils.EMPTY, WiFiSignal.EMPTY);

    private final List<WiFiDetail> children;
    private final String SSID;
    private final String BSSID;
    private final String capabilities;
    private final WiFiSignal wiFiSignal;
    private final WiFiAdditional wiFiAdditional;


    public WiFiDetail(@NonNull String SSID, @NonNull String BSSID, @NonNull String capabilities,
                      @NonNull WiFiSignal wiFiSignal, @NonNull WiFiAdditional wiFiAdditional) {
        this.SSID = SSID;
        this.BSSID = BSSID;
        this.capabilities = capabilities;
        this.wiFiSignal = wiFiSignal;
        this.wiFiAdditional = wiFiAdditional;
        this.children = new ArrayList<>();
    }

    public WiFiDetail(@NonNull String SSID, @NonNull String BSSID, @NonNull String capabilities, @NonNull WiFiSignal wiFiSignal) {
        this(SSID, BSSID, capabilities, wiFiSignal, WiFiAdditional.EMPTY);
    }

    public WiFiDetail(@NonNull WiFiDetail wiFiDetail, @NonNull WiFiAdditional wiFiAdditional) {
        this(wiFiDetail.getSSID(), wiFiDetail.getBSSID(), wiFiDetail.getCapabilities(), wiFiDetail.getWiFiSignal(), wiFiAdditional);
    }

    public Security getSecurity() {
        return Security.findOne(capabilities);
    }

    public String getSSID() {
        return StringUtils.isBlank(SSID) ? "***" : SSID;
    }

    public String getBSSID() {
        return BSSID;
    }

    public String getCapabilities() {
        return capabilities;
    }

    public WiFiSignal getWiFiSignal() {
        return wiFiSignal;
    }

    public WiFiAdditional getWiFiAdditional() {
        return wiFiAdditional;
    }

    public List<WiFiDetail> getChildren() {
        return children;
    }


    public String getTitle() {
        if (StringUtils.isBlank(getWiFiAdditional().getIPAddress()))
            return String.format("%s", getSSID());
        else return String.format("%s [%s]", getSSID(), getWiFiAdditional().getIPAddress());
    }

    public String getTitleAndMAC() {
        return String.format("%s (%s)", getSSID(), getBSSID());
    }


    public void addChild(@NonNull WiFiDetail wiFiDetail) {
        children.add(wiFiDetail);
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) return true;

        if (other == null || getClass() != other.getClass()) return false;

        WiFiDetail otherDetail = (WiFiDetail) other;
        return new EqualsBuilder()
                .append(getSSID(), (otherDetail).getSSID())
                .append(getBSSID(), (otherDetail).getBSSID())
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(getSSID())
                .append(getBSSID())
                .toHashCode();
    }

    @Override
    public int compareTo(@NonNull WiFiDetail another) {
        return new CompareToBuilder()
                .append(getSSID(), another.getSSID())
                .append(getBSSID(), another.getBSSID())
                .toComparison();
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

}