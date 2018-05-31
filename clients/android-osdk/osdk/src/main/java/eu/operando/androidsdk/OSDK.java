package eu.operando.androidsdk;

import android.content.Context;
import android.util.Log;

import com.github.fge.jsonschema.core.exceptions.ProcessingException;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Created by Edy on 05-May-17.
 */

public class OSDK {
    private static final String TAG = "OSDK";

    public static void init(Context context) {

        try {
            InputStream schema = context.getAssets().open("schema.json");
            InputStream scd = context.getAssets().open("AppSCD.json");
            String inputStr;
            StringBuilder schemaStringBuilder = new StringBuilder();
            BufferedReader reader = new BufferedReader(new InputStreamReader(schema));
            while ((inputStr = reader.readLine()) != null) {
                schemaStringBuilder.append(inputStr);
            }
            StringBuilder scdStringBuilder = new StringBuilder();
            reader = new BufferedReader(new InputStreamReader(scd));
            while ((inputStr = reader.readLine()) != null) {
                scdStringBuilder.append(inputStr);
            }

            Log.e(TAG, "OSDKLOG schema: " + schemaStringBuilder.toString());
            Log.e(TAG, "OSDKLOG scd: " + scdStringBuilder.toString());
            boolean valid = ValidationUtils.isJsonValid(schemaStringBuilder.toString(), scdStringBuilder.toString());
            if(!valid){
                throw new SecurityException("scd.json doesn't match the schema");
            }
        } catch (FileNotFoundException e) {
            throw new SecurityException("SCD document not found. Please add scd.json to the assets folder");
        } catch (ProcessingException | IOException e) {
            e.printStackTrace();
        }

    }
}
