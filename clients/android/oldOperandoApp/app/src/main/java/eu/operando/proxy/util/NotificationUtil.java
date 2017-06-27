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

import android.app.Application;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.support.v4.app.NotificationCompat;

import java.util.Set;

import eu.operando.R;
import eu.operando.proxy.MainContext;


/**
 * Created by nikos on 5/6/16.
 */
public class NotificationUtil {
    NotificationCompat.Builder notificationBuilder = null;
    private Context context = MainContext.INSTANCE.getContext();

    private static final int mainNotificationId = 1;


    //TODO: Perikis
    public void displayExfiltratedNotification(String applicationInfo, Set<RequestFilterUtil.FilterType> exfiltrated) {
        notificationBuilder = new NotificationCompat.Builder(context)
                .setContentTitle(applicationInfo)
                .setContentText(RequestFilterUtil.messageForMatchedFilters(exfiltrated))
                .setAutoCancel(true)
                .setOngoing(false)
                .setPriority(Notification.PRIORITY_HIGH)
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher))
                .setSmallIcon(R.mipmap.ic_launcher); //android.R.color.transparent

        /* Heads-up */
        if (Build.VERSION.SDK_INT >= 22) notificationBuilder.setVibrate(new long[0]);

        Notification notification = notificationBuilder.build();
        /* http://javatechig.com/android/android-notification-example-using-notificationcompat */
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Application.NOTIFICATION_SERVICE);
        notificationManager.notify(mainNotificationId, notification);
    }
}
