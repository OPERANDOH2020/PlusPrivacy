package eu.operando.osdk.eula.visitedparts;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import eu.operando.osdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.osdk.scdmodel.AccessFrequencyType;
import eu.operando.osdk.scdmodel.InputType;
import eu.operando.osdk.scdmodel.ScdModel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class AccessFrequencyPartTextBuilder implements ITextBuilderPart {

    private ScdModel scd;

    public AccessFrequencyPartTextBuilder(ScdModel scd) {
        this.scd = scd;
    }

    public String build() {

        StringBuilder frequencyPart = new StringBuilder();
        Map<AccessFrequencyType, List<ScdModel.AccessedInputs>> sensorsPerAccessFrequency =
                this.aggregateBasedOnAccessFrequensy(scd.getAccessedInputs());

        for (AccessFrequencyType type : AccessFrequencyType.values()) {
            List<ScdModel.AccessedInputs> afArray = sensorsPerAccessFrequency.get(type);

            if (afArray.size() > 0) {
                frequencyPart.append("\nThe following sensor");

                if (afArray.size() > 1) {
                    frequencyPart.append("s, ");
                } else {
                    frequencyPart.append(", ");
                }

                for (ScdModel.AccessedInputs sensor : afArray) {
                    frequencyPart.append(InputType.valueOf(sensor.getInputType()).getSensor())
                            .append(", ");
                }

                if (afArray.size() > 1) {
                    frequencyPart.append("have ");
                } else {
                    frequencyPart.append("has ");
                }

                frequencyPart.append("an access frequency of type \"")
                        .append(type.toString())
                        .append("\". ")
                        .append(type.getFrequency());
            }
        }

        return frequencyPart.toString();
    }

    private Map<AccessFrequencyType, List<ScdModel.AccessedInputs>> aggregateBasedOnAccessFrequensy
            (List<ScdModel.AccessedInputs> sensors) {

        Map<AccessFrequencyType, List<ScdModel.AccessedInputs>> result = new TreeMap<>();

        for (AccessFrequencyType type : AccessFrequencyType.values()) {
            result.put(type, new ArrayList<ScdModel.AccessedInputs>());
        }

        for (ScdModel.AccessedInputs sensor : sensors) {
            result.get(AccessFrequencyType.valueOf(sensor.getAccessFrequency())).add(sensor);
        }
        return result;
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        textBuilderVisitor.visit(this);
    }
}
