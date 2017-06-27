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

import android.content.Context;
import android.database.Cursor;
import android.provider.ContactsContract;
import android.telephony.PhoneNumberUtils;
import android.telephony.TelephonyManager;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import eu.operando.proxy.util.LocationHelper.GPSTracker;


/**
 * Created by nikos on 23/5/2016.
 */
public class RequestFilterUtil {
    Context context;
    TelephonyManager telephonyManager;
    GPSTracker gpsTracker;


    String[] contactsInfo;
    String[] phoneInfo;

    public RequestFilterUtil(Context context) {
        this.context = context;
        telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        gpsTracker = new GPSTracker(context);
        this.contactsInfo = genContactsInfo();
        this.phoneInfo = genPhoneInfo();
    }

    public String[] genPhoneInfo() {
        String IMEI = telephonyManager.getDeviceId();
        String phoneNumber = telephonyManager.getLine1Number();
        String subscriberID = telephonyManager.getSubscriberId(); //IMSI
        String carrierName = telephonyManager.getNetworkOperatorName();
        String androidId = android.provider.Settings.Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
        return new String[]{IMEI, phoneNumber, subscriberID, carrierName};
    }


    public String[] genContactsInfo() {
        Cursor phones = context.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, null);
        Set<String> ret = new HashSet<>();
        while (phones.moveToNext()) {
            //String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
            String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
            String normalizedNumber = PhoneNumberUtils.normalizeNumber(phoneNumber);
            String normalizedNumber2 = PhoneNumberUtils.stripSeparators(phoneNumber);
            //ret.add(name);
            ret.add(phoneNumber);
            ret.add(normalizedNumber);
            ret.add(normalizedNumber2);
        }
        phones.close();
        return ret.toArray(new String[ret.size()]);
    }

    public String[] getContactsInfo() {
        return contactsInfo;
    }

    public String[] getPhoneInfo() {
        return phoneInfo;
    }

    public String[] getLocationInfo() {
        List<String> ret = new ArrayList<>();
        for (String loc : gpsTracker.getLocations()) {
            if (loc.length() >= 10)
                loc = loc.substring(0, loc.length() - 4);
            ret.add(loc);
        }
        return ret.toArray(new String[ret.size()]);
    }


    public enum FilterType {
        CONTACTS,
        PHONEINFO,
        LOCATION
    }

    public static String getDescriptionForFilterType(FilterType filterType) {
        switch (filterType) {
            case CONTACTS:
                return "Contacts Data";
            case PHONEINFO:
                return "Phone Information";
            case LOCATION:
                return "Location Information";
            default:
                return "Undefined";
        }
    }

    public static String messageForMatchedFilters(Set<FilterType> exfiltrated) {
        StringBuilder message = new StringBuilder();
        for (RequestFilterUtil.FilterType filterType : exfiltrated) {
            if (message.length() > 0) {
                message.append(", ");
            }
            message.append(RequestFilterUtil.getDescriptionForFilterType(filterType));
        }
        return message.toString();
    }


    @Deprecated
    public static String[] genDummyForArray(String[] arr) {
        String[] dummy = new String[arr.length];
        for (int i = 0; i < arr.length; i++) {
            String str = arr[i];
            dummy[i] = str.replaceAll("\\d", "0");
        }
        return dummy;
    }
}
