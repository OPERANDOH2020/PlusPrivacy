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
import android.support.annotation.NonNull;
import android.text.Editable;
import android.text.TextWatcher;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;

import eu.operando.R;
import eu.operando.proxy.wifi.model.Security;
import eu.operando.proxy.wifi.model.WiFiDetail;
import proxysetter.ProxyChangeAsync;
import proxysetter.ProxyChangeParams;


/**
 * Created by nikos on 5/8/16.
 */

public class ConnectClickListener implements View.OnClickListener {
    private WiFiDetail wiFiDetail;
    private Context context;
    private LayoutInflater layoutInflater;
    private EditText etConnectPwd;
    private CheckBox cbCheckPwd;

    public ConnectClickListener(@NonNull Context context, @NonNull WiFiDetail wiFiDetail, @NonNull LayoutInflater layoutInflater) {
        this.context = context;
        this.wiFiDetail = wiFiDetail;
        this.layoutInflater = layoutInflater;
    }

    @Override
    public void onClick(View v) {

        if (wiFiDetail.getSecurity() == Security.NONE) {
            connectWifi(null);
            return;
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        View dialogView = layoutInflater.inflate(R.layout.connect_dialog, null);
        builder.setTitle(wiFiDetail.getSSID());

        // CONNECT BUTTON
        builder.setNegativeButton(android.R.string.cancel, null);
        builder.setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int id) {
                connectWifi(etConnectPwd.getText().toString());
            }
        });

        final AlertDialog dialog = builder.create();
        dialog.setView(dialogView);

        // SSID
        //dialog.setMessage(wiFiDetail.getSSID());

        //Show key checkbox
        cbCheckPwd = (CheckBox) dialogView.findViewById(R.id.cb_check_pwd);
        cbCheckPwd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (cbCheckPwd.isChecked()) {
                    etConnectPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                } else {
                    etConnectPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
                }
            }
        });

        //Key textfield
        etConnectPwd = (EditText) dialogView.findViewById(R.id.et_connect_pwd);
        etConnectPwd.addTextChangedListener(new TextWatcher() {
            @Override
            public void afterTextChanged(Editable s) {
                if (s.length() >= 8) {
                    dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(true);
                } else dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }
        });

        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override
            public void onShow(DialogInterface dialog) {
                ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);
            }
        });


        dialog.show();

    }

    private void connectWifi(String password) {
        Intent in = new Intent();
        in.putExtra(ProxyChangeParams.SSID, wiFiDetail.getSSID());
        if (password != null) in.putExtra(ProxyChangeParams.KEY, password);
        in.putExtra(ProxyChangeParams.HOST, "127.0.0.1");
        in.putExtra(ProxyChangeParams.PORT, "8899");
        Log.e("OPERANDO", "Connection details -->" + wiFiDetail.getSSID() + " : " + password);
        new ProxyChangeAsync(context).execute(in);
    }
}
