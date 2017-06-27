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

package eu.operando.proxy.wifi.scanner;

import android.net.wifi.ScanResult;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import eu.operando.proxy.wifi.band.WiFiWidth;
import eu.operando.proxy.wifi.model.WiFiConnection;
import eu.operando.proxy.wifi.model.WiFiData;
import eu.operando.proxy.wifi.model.WiFiDetail;
import eu.operando.proxy.wifi.model.WiFiSignal;
import eu.operando.proxy.wifi.model.WiFiUtils;

public class Transformer {

    protected WiFiConnection transformWifiInfo(WifiInfo wifiInfo) {
        if (wifiInfo == null || wifiInfo.getNetworkId() == -1) {
            return WiFiConnection.EMPTY;
        }
        return new WiFiConnection(
                WiFiUtils.convertSSID(wifiInfo.getSSID()),
                wifiInfo.getBSSID(),
                WiFiUtils.convertIpAddress(wifiInfo.getIpAddress()),
                wifiInfo.getLinkSpeed());
    }

    protected List<String> transformWifiConfigurations(List<WifiConfiguration> configuredNetworks) {
        List<String> results = new ArrayList<>();
        if (configuredNetworks != null) {
            for (WifiConfiguration wifiConfiguration : configuredNetworks) {
                results.add(WiFiUtils.convertSSID(wifiConfiguration.SSID));
            }
        }
        return Collections.unmodifiableList(results);
    }

    //TODO: here comes the sun
    protected List<WiFiDetail> transformScanResults(List<ScanResult> scanResults) {
        List<WiFiDetail> results = new ArrayList<>();
        if (scanResults != null) {
            for (ScanResult scanResult : scanResults) {
                WiFiSignal wiFiSignal = new WiFiSignal(scanResult.frequency, getWiFiWidth(scanResult), scanResult.level);
                WiFiDetail wiFiDetail = new WiFiDetail(scanResult.SSID, scanResult.BSSID, scanResult.capabilities, wiFiSignal);

                results.add(wiFiDetail);
            }
        }
        return Collections.unmodifiableList(results);
    }

    private WiFiWidth getWiFiWidth(ScanResult scanResult) {
        try {
            return WiFiWidth.find((int) scanResult.getClass().getDeclaredField(Fields.channelWidth.name()).get(scanResult));
        } catch (Exception e) {
            // Not APK 23+ can not convert
            return WiFiWidth.MHZ_20;
        }
    }

    /*
    transformToWiFiData
     */
    public WiFiData transformToWiFiData(List<ScanResult> scanResults, WifiInfo wifiInfo, List<WifiConfiguration> configuredNetworks) {
        List<WiFiDetail> wiFiDetails = transformScanResults(scanResults);
        WiFiConnection wiFiConnection = transformWifiInfo(wifiInfo);
        return new WiFiData(wiFiDetails, wiFiConnection, configuredNetworks);
    }

    private enum Fields {
        /*
                centerFreq0,
                centerFreq1,
        */
        channelWidth
    }

}
