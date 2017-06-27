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

package eu.operando.proxy.util;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.LayoutInflater;

import com.squareup.otto.Bus;
import com.squareup.otto.ThreadEnforcer;


import java.util.List;

import be.shouldit.proxy.lib.APL;
import eu.operando.R;
import eu.operando.proxy.MainContext;
import eu.operando.proxy.OperandoStatusEvent;
import eu.operando.proxy.database.DatabaseHelper;
import eu.operando.proxy.service.ProxyService;
import eu.operando.proxy.settings.Settings;
import eu.operando.proxy.wifi.scanner.Scanner;
import eu.operando.proxy.wifi.scanner.Transformer;
import mitm.Authority;

/**
 * Created by nikos on 5/6/16.
 */
public class MainUtil {


    public static void initializeMainContext(@NonNull Context applicationContext) {
        Log.e("OPERANDO", " -- INITIALIZING MAIN CONTEXT --");
        MainContext mainContext = MainContext.INSTANCE;
        if (mainContext.getContext() == null) {
            Log.e("OPERANDO", " -- main context is NULL ! --");
            WifiManager wifiManager = (WifiManager) applicationContext.getSystemService(Context.WIFI_SERVICE);
            Handler handler = new Handler();
            Settings settings = new Settings(applicationContext);
            Resources resources = applicationContext.getResources();
            Authority authority = new Authority(applicationContext);
            DatabaseHelper db = new DatabaseHelper(applicationContext);
            Bus bus = new Bus(ThreadEnforcer.ANY);
            mainContext.setContext(applicationContext);
            mainContext.setAuthority(authority);
            mainContext.setResources(resources);
            mainContext.setSettings(settings);
            mainContext.setDatabaseHelper(db);
            mainContext.setBUS(bus);
            mainContext.setLayoutInflater((LayoutInflater) applicationContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE));
            mainContext.setScanner(new Scanner(wifiManager, handler, settings, new Transformer()));
            mainContext.setNotificationUtil(new NotificationUtil());
            mainContext.setSharedPreferences(applicationContext.getSharedPreferences(resources.getString(R.string.app_name), Context.MODE_PRIVATE));
            setUpAPL(applicationContext);
        }

    }

    public static void setUpAPL(@NonNull Context context) {
        APL.setup(context);
    }

    // Needed for catching netty messages...


    //Auto ISWS na prepei na ta valw sto Context tou Boot Notification Listener
    public static void startProxyService(@NonNull MainContext mainContext) {
        Context context = mainContext.getContext();
        if (MainUtil.isServiceRunning(context, ProxyService.class)) return;
        Intent intent = new Intent(context, ProxyService.class);
        //Get this from settings
        intent.putExtra("port", 8899);
        context.startService(intent);
    }

    public static boolean isProxyPaused(@NonNull MainContext mainContext) {
        return mainContext.getSharedPreferences().getBoolean("proxyPaused", false);
    }

    public static void setProxyPaused(@NonNull MainContext mainContext, boolean paused) {
        SharedPreferences.Editor editor = mainContext.getSharedPreferences().edit();
        editor.putBoolean("proxyPaused", paused);
        editor.commit();
        mainContext.getBUS().post(new OperandoStatusEvent(OperandoStatusEvent.EventType.ProxyState));
    }

//    public static void reStartProxyService(){
//        if(!MainUtil.isServiceRunning(getApplicationContext(),ProxyService.class)){
//            startProxyService();
//            return;
//        }
//        Intent intent = new Intent(getApplicationContext(),ProxyService.class);
//        stopService(intent);
//        //Get this from settings
//        intent.putExtra("port", 9000);
//        startService(intent);
//    }

    public static boolean isServiceRunning(Context context, Class<?> serviceClass) {
        final ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        final List<ActivityManager.RunningServiceInfo> services = activityManager.getRunningServices(Integer.MAX_VALUE);
        for (ActivityManager.RunningServiceInfo runningServiceInfo : services) {
            if (runningServiceInfo.service.getClassName().equals(serviceClass.getName())) {
                return true;
            }
        }
        return false;
    }

}
