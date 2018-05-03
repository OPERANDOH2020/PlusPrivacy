package eu.operando.androidsdk.eula.visitedparts;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import eu.operando.androidsdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.androidsdk.scdmodel.ScdModel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class EulaTextBuilder implements ITextBuilderPart {

    private ITextBuilderPart[] parts;
    private Context context;
    private ScdModel scd;

    public EulaTextBuilder(Context context, String filename) {
        this.context = context;
        generateEulaFrom(filename);
    }

    private void generateEulaFrom(String filename) {
        scd = new Gson().fromJson(readScdJson(filename), ScdModel.class);
        Log.e("scdModel", scd.toString());

        parts = new ITextBuilderPart[]{

                new IntroPartTextBuilder(scd.getTitle()),
                new DownloadDataPartTextBuilder(scd),
                new SensorPartTextBuilder(scd),
                new AccessFrequencyPartTextBuilder(scd),
                new UserControlPartTextBuilder(scd)
        };
    }

    private String readScdJson(String filename) {
        StringBuilder scdStringBuilder = new StringBuilder();
        try {
            InputStream scd_file = context.getAssets().open(filename);

            String inputStr;
            BufferedReader reader = new BufferedReader(new InputStreamReader(scd_file));
            while ((inputStr = reader.readLine()) != null) {
                scdStringBuilder.append(inputStr);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return scdStringBuilder.toString();
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        for (int i = 0; i < parts.length; i++) {
            parts[i].accept(textBuilderVisitor);
        }
    }

}
