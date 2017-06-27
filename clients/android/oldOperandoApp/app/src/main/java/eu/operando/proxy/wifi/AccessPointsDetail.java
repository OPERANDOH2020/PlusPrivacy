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

import android.content.Context;
import android.content.res.Resources;
import android.net.wifi.WifiInfo;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import org.apache.commons.lang3.StringUtils;

import be.shouldit.proxy.lib.WiFiApConfig;
import eu.operando.R;
import eu.operando.proxy.MainContext;
import eu.operando.proxy.wifi.listeners.ConfiguredClickListener;
import eu.operando.proxy.wifi.listeners.ConnectClickListener;
import eu.operando.proxy.wifi.listeners.ForgetClickListener;
import eu.operando.proxy.wifi.model.Security;
import eu.operando.proxy.wifi.model.Strength;
import eu.operando.proxy.wifi.model.WiFiConnection;
import eu.operando.proxy.wifi.model.WiFiDetail;
import eu.operando.proxy.wifi.model.WiFiSignal;

public class AccessPointsDetail {

    private MainContext mainContext = MainContext.INSTANCE;
    private Context context;

    public AccessPointsDetail(Context context) {
        this.context = context;
    }


    //TODO: Make the values dynamic
    private boolean isOperandoCompatible(WiFiApConfig wiFiApConfig) {
        String proxyHost = wiFiApConfig.getProxyHostString();
        return (StringUtils.isNotBlank(proxyHost) && proxyHost.equals("127.0.0.1") && wiFiApConfig.getProxyPort() == 8899);
    }


    public void setView(@NonNull Resources resources, @NonNull View view, @NonNull final WiFiDetail wiFiDetail) {

        TextView ssidLabel = (TextView) view.findViewById(R.id.ssid);
        ssidLabel.setText(wiFiDetail.getTitle());
        TextView textLinkSpeed = (TextView) view.findViewById(R.id.linkSpeed);
        String ipAddress = wiFiDetail.getWiFiAdditional().getIPAddress();
        boolean isConnected = StringUtils.isNotBlank(ipAddress);
        if (!isConnected) {
            textLinkSpeed.setVisibility(View.GONE);
            ssidLabel.setTextColor(resources.getColor(android.R.color.white));
        } else {
            ssidLabel.setTextColor(resources.getColor(R.color.connected));

            int linkSpeed = wiFiDetail.getWiFiAdditional().getLinkSpeed();
            if (linkSpeed == WiFiConnection.LINK_SPEED_INVALID) {
                textLinkSpeed.setVisibility(View.GONE);
            } else {
                textLinkSpeed.setVisibility(View.VISIBLE);
                textLinkSpeed.setText(String.format("%d%s", linkSpeed, WifiInfo.LINK_SPEED_UNITS));
            }
        }

        WiFiSignal wiFiSignal = wiFiDetail.getWiFiSignal();
        Strength strength = wiFiSignal.getStrength();
        ImageView imageView = (ImageView) view.findViewById(R.id.levelImage);
        imageView.setImageResource(strength.imageResource());
        imageView.setColorFilter(resources.getColor(strength.colorResource()));

        Security security = wiFiDetail.getSecurity();
        ImageView securityImage = (ImageView) view.findViewById(R.id.securityImage);
        securityImage.setImageResource(security.imageResource());
        securityImage.setColorFilter(resources.getColor(R.color.icons_color));

        TextView textLevel = (TextView) view.findViewById(R.id.level);
        textLevel.setText(String.format("%ddBm", wiFiSignal.getLevel()));
        textLevel.setTextColor(resources.getColor(strength.colorResource()));

        ((TextView) view.findViewById(R.id.channel)).setText(String.format("%d", wiFiSignal.getWiFiChannel().getChannel()));
        ((TextView) view.findViewById(R.id.frequency)).setText(String.format("%d%s", wiFiSignal.getFrequency(), WifiInfo.FREQUENCY_UNITS));
        ((TextView) view.findViewById(R.id.distance)).setText(String.format("%.1fm", wiFiSignal.getDistance()));
        ((TextView) view.findViewById(R.id.capabilities)).setText(wiFiDetail.getCapabilities());


        LayoutInflater layoutInflater = mainContext.getLayoutInflater();

        final WiFiApConfig wiFiApConfig = wiFiDetail.getWiFiAdditional().getWiFiApConfig();
        ImageView configuredImage = (ImageView) view.findViewById(R.id.configuredImage);
        if (wiFiApConfig != null) {

            configuredImage.setVisibility(View.VISIBLE);

            if (isOperandoCompatible(wiFiApConfig)) {
                configuredImage.setColorFilter(resources.getColor(android.R.color.holo_green_light));
                view.setOnClickListener(new ConfiguredClickListener(context, wiFiDetail, wiFiApConfig, isConnected));
            } else {
                configuredImage.setColorFilter(resources.getColor(android.R.color.holo_red_light));
                view.setOnClickListener(new ForgetClickListener(context, wiFiDetail));
            }

        } else {
            configuredImage.setVisibility(View.GONE);
            view.setOnClickListener(new ConnectClickListener(context, wiFiDetail, layoutInflater));
        }


    }

}
