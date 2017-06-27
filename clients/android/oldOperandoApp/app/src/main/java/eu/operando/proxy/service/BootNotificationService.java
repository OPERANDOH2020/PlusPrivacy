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

package eu.operando.proxy.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;


import java.security.GeneralSecurityException;

import eu.operando.proxy.MainContext;
import eu.operando.proxy.util.CertificateUtil;
import eu.operando.proxy.util.MainUtil;
import mitm.Authority;
import mitm.BouncyCastleSslEngineSource;


public class BootNotificationService extends Service {

    private MainContext mainContext = MainContext.INSTANCE;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        MainUtil.initializeMainContext(getApplicationContext());
        Authority authority = new Authority(getApplicationContext());
        try {
            if (CertificateUtil.isCACertificateInstalled(authority.aliasFile(BouncyCastleSslEngineSource.KEY_STORE_FILE_EXTENSION),
                    BouncyCastleSslEngineSource.KEY_STORE_TYPE,
                    authority.password())) {
                MainUtil.startProxyService(mainContext);
            }
        } catch (GeneralSecurityException ex) {
            ex.printStackTrace();
        }

        /* AN apotyxei o proxy, tote allazw to notification" */
        //mainContext.getNotificationUtil().showDisconnectedNotification();
        return START_STICKY;
    }


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

}
