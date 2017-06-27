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

package eu.operando.proxy.wifi.listeners;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.wifi.WifiManager;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.view.View;

import be.shouldit.proxy.lib.WiFiApConfig;
import eu.operando.proxy.wifi.model.WiFiDetail;

/**
 * Created by nikos on 19/5/2016.
 */
public class ConfiguredClickListener implements View.OnClickListener {

    private Context context;
    private WiFiApConfig wiFiApConfig;
    private boolean isConnected;
    private WiFiDetail wiFiDetail;

    public ConfiguredClickListener(@NonNull Context context, @NonNull WiFiDetail wiFiDetail, @NonNull WiFiApConfig wiFiApConfig, boolean isConnected) {
        this.context = context;
        this.wiFiApConfig = wiFiApConfig;
        this.isConnected = isConnected;
        this.wiFiDetail = wiFiDetail;
    }


    @Override
    public void onClick(View v) {
        final WifiManager wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        final int netId = wiFiApConfig.getNetworkId();
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(wiFiDetail.getSSID());
        builder.setNegativeButton(android.R.string.cancel, null);
        DialogInterface.OnClickListener posListener;
        String message;
        String posButton;
        if (isConnected) {
            message = "You are already connected to an OperandoApp configured network. You can 'Forget' it via the Wifi Settings.";
            posButton = "Open Wifi Settings";
            posListener = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int id) {
                    /*
                    We could also use this:
                    https://github.com/VicV/syde/blob/master/Android/Litterary/app/src/main/java/com/jarone/litterary/helpers/WifiHelper.java
                     */
                    context.startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
                }
            };
        } else {
            message = "Do you want to connect ?";
            posButton = "Connect";
            posListener = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int id) {
                    wifiManager.disconnect();
                    wifiManager.enableNetwork(netId, true);
                    wifiManager.reconnect();
                }
            };

        }
        builder.setPositiveButton(posButton, posListener);
        builder.setMessage(message);
        builder.create().show();

    }

}