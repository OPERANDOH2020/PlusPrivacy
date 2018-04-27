package eu.operando.osdk.eula.visitedparts;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import eu.operando.osdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.osdk.scdmodel.InputType;
import eu.operando.osdk.scdmodel.ScdModel;
import eu.operando.osdk.scdmodel.UsageLevelType;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SensorPartTextBuilder implements ITextBuilderPart {

    private ScdModel scd;
    private Map<UsageLevelType, String> privacyLevelShortNames;
    private Map<UsageLevelType, String> privacyLevelDescriptions;

    public SensorPartTextBuilder(ScdModel scd) {
        this.scd = scd;
        initializePrivacyLevelShortNames();
        initializePrivacyLevelDescriptions();
    }

    private void initializePrivacyLevelDescriptions() {
        privacyLevelDescriptions = new HashMap();
        privacyLevelDescriptions.put(UsageLevelType.LocalOnly, "The data collected under this" +
                " privacy level is used locally only.");
        privacyLevelDescriptions.put(UsageLevelType.AggregateOnly, "Under this privacy level," +
                " bulks of data are sent to the vendor of the app, in an anonymised method " +
                "(i.e. via https) and they may link the data to your account/ id if any.");
        privacyLevelDescriptions.put(UsageLevelType.DPCompatible, "Bulks of data are sent " +
                "securely (i.e via https) to the vendor of the app, in a manner that guarantees " +
                "the data does not link back to your account/id if any.");
        privacyLevelDescriptions.put(UsageLevelType.SelfUseOnly, "De discutat cu Sinica");
        privacyLevelDescriptions.put(UsageLevelType.SharedWithThirdParty, "The data is shared " +
                "with a list of of specified third parties");
        privacyLevelDescriptions.put(UsageLevelType.Unspecified, "The vendor of the app does " +
                "not disclose the manner in which this data is used.");
    }

    private void initializePrivacyLevelShortNames() {
        privacyLevelShortNames = new HashMap();
        privacyLevelShortNames.put(UsageLevelType.LocalOnly, "Local-Only");
        privacyLevelShortNames.put(UsageLevelType.AggregateOnly, "Only-Aggregate");
        privacyLevelShortNames.put(UsageLevelType.DPCompatible, "DP-Compatible");
        privacyLevelShortNames.put(UsageLevelType.SelfUseOnly, "Self-Use Only");
        privacyLevelShortNames.put(UsageLevelType.SharedWithThirdParty, "ThirdParty-Shared");
        privacyLevelShortNames.put(UsageLevelType.Unspecified, "Unspecified-Usages");
    }

    public String build() {

        if (scd.getAccessedInputs().size() < 1) {
            return null;
        }

        StringBuilder sensorsPart = new StringBuilder();

        Map<Integer, List<ScdModel.AccessedInputs>> aggregatedSensors =
                this.aggregateBasedOnPrivacyLevel(scd.getAccessedInputs());

        List<UsageLevelType> list = Arrays.asList(UsageLevelType.values());
        Collections.reverse(list);

        for (int i = 1; i <= list.toArray().length; ++i) {

            List<ScdModel.AccessedInputs> sensorsAtLevelI = aggregatedSensors.get(i);
            if (sensorsAtLevelI.size() > 0) {
                sensorsPart.append(buildTextForSensorsAtLevel(sensorsAtLevelI));
            }
        }
        return sensorsPart.toString();
    }

    private String buildTextForSensorsAtLevel(List<ScdModel.AccessedInputs> sensorsAtLevelI) {
        StringBuilder sensorsPart = new StringBuilder();
        StringBuilder sensorNames = new StringBuilder();

        for (ScdModel.AccessedInputs sensor : sensorsAtLevelI) {
            sensorNames.append(InputType.valueOf(sensor.getInputType()).getSensor())
                    .append(", ");
        }

        sensorsPart.append("\nThe following sensor");
        if (sensorsAtLevelI.size() > 1) {
            sensorsPart.append("s, ");
        } else {
            sensorsPart.append(", ");
        }

        sensorsPart.append(sensorNames);
        if (sensorsAtLevelI.size() > 1) {
            sensorsPart.append(" are ");
        } else {
            sensorsPart.append(" is ");
        }

        int usageLevel = sensorsAtLevelI.get(0).getPrivacyDescription().getUsageLevel();
        sensorsPart.append("located under the privacy level PL")
                .append(usageLevel)
                .append(", that is \"")
                .append(privacyLevelShortNames.get(UsageLevelType.values()[usageLevel - 1]))
                .append("\". ")
                .append(privacyLevelDescriptions.get(UsageLevelType.values()[usageLevel - 1]));

        if (UsageLevelType.SharedWithThirdParty.getLevel() == usageLevel) {
            sensorsPart.append("\nThese are listed as follows:\n\n");
            for (ScdModel.AccessedInputs sensor : sensorsAtLevelI) {
                sensorsPart.append("For ")
                        .append(InputType.valueOf(sensor.getInputType()).getSensor())
                        .append("\n\n")
                        .append(this.buildLevel5ThirdPartiesText(sensor));
            }
        }
        sensorsPart.append("\n");
        return sensorsPart.toString();
    }

    private String buildLevel5ThirdPartiesText(ScdModel.AccessedInputs sensor) {

        if (sensor.getPrivacyDescription().getThirdParties().size() == 0) {
            return "-There are no third parties specified for this sensor-";
        }
        StringBuilder thirdPartiesText = new StringBuilder();
        for (ScdModel.AccessedInputs.PrivacyDescription.ThirdParty thirdParty : sensor
                .getPrivacyDescription().getThirdParties()) {
            thirdPartiesText.append(thirdParty.getName()).append("\n");
            thirdPartiesText.append(thirdParty.getUrl());
        }
        return thirdPartiesText.toString();
    }

    private Map<Integer, List<ScdModel.AccessedInputs>> aggregateBasedOnPrivacyLevel
            (List<ScdModel.AccessedInputs> sensors) {
        Map<Integer, List<ScdModel.AccessedInputs>> result = new HashMap<>();

        for (UsageLevelType type : UsageLevelType.values()) {
            result.put(type.getLevel(), new ArrayList<ScdModel.AccessedInputs>());
        }

        for (ScdModel.AccessedInputs sensor : sensors) {
            result.get(sensor.getPrivacyDescription().getUsageLevel()).add(sensor);
        }

        return result;
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        textBuilderVisitor.visit(this);
    }
}
