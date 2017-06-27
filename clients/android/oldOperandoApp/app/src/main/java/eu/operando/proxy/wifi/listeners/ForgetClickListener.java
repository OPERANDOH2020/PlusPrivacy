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
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.view.View;

import eu.operando.proxy.wifi.model.WiFiDetail;


/**
 * Created by nikos on 5/8/16.
 */
public class ForgetClickListener implements View.OnClickListener {
    private WiFiDetail wiFiDetail;
    private Context context;

    public ForgetClickListener(@NonNull Context context, @NonNull WiFiDetail wiFiDetail) {
        this.context = context;
        this.wiFiDetail = wiFiDetail;
    }

    @Override
    public void onClick(View v) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(wiFiDetail.getSSID());
        builder.setPositiveButton(android.R.string.cancel, null);
        builder.setNegativeButton("Open Wifi Settings", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int id) {
                context.startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
            }
        });
        String message = "This wifi network is not configured for use with OperandoApp. You will need to 'Forget' it first.";
        builder.setMessage(message);
        builder.create().show();
    }

}
