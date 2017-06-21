package eu.operando.util;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by raluca on 08.04.2016.
 */
public class SharedPreferencesService {


    private static SharedPreferencesService mSharedPreferencesService;
    private SharedPreferences mSharedPreferences;
    private SharedPreferences.Editor mEditor;

    private static Context mContext;

    private  SharedPreferencesService (){
        mSharedPreferences = mContext.getSharedPreferences(mContext.getPackageName(),
                mContext.MODE_PRIVATE);
        mEditor = mSharedPreferences.edit();
    }


    public static SharedPreferencesService getInstance(Context context){
        if (mSharedPreferencesService==null){
            mContext = context;
            mSharedPreferencesService = new SharedPreferencesService();
        }
        return mSharedPreferencesService;
    }


    public String getUserEmail() {
        return mSharedPreferences.getString(Constants.sharedPreferences.EMAIL_KEY, "");
    }

    public void setUserEmail(String email) {
        mEditor.putString(Constants.sharedPreferences.EMAIL_KEY, email);
        mEditor.commit();
    }
}
