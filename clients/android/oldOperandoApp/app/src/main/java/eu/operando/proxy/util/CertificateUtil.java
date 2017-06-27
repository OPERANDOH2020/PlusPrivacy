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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.util.Date;
import java.util.Enumeration;

/**
 * Created by nikos on 5/6/16.
 */
public class CertificateUtil {

    public static boolean isCACertificateInstalled(File fileCA, String type, char[] password) throws KeyStoreException {

        KeyStore keyStoreCA = null;
        try {
            keyStoreCA = KeyStore.getInstance(type/*, "BC"*/);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (fileCA.exists() && fileCA.canRead()) {
            try {
                FileInputStream fileCert = new FileInputStream(fileCA);
                keyStoreCA.load(fileCert, password);
                fileCert.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (java.security.cert.CertificateException e) {
                e.printStackTrace();
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Enumeration ex = keyStoreCA.aliases();
            Date exportFilename = null;
            String caAliasValue = "";

            while (ex.hasMoreElements()) {
                String is = (String) ex.nextElement();
                Date lastStoredDate = keyStoreCA.getCreationDate(is);
                if (exportFilename == null || lastStoredDate.after(exportFilename)) {
                    exportFilename = lastStoredDate;
                    caAliasValue = is;
                }
            }

            try {
                return keyStoreCA.getKey(caAliasValue, password) != null;
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch (UnrecoverableKeyException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
