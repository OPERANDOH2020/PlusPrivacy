package eu.operando.osdk.eula.visitedparts;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import eu.operando.osdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.osdk.scdmodel.InputType;
import eu.operando.osdk.scdmodel.ScdModel;
import eu.operando.osdk.scdmodel.UserControlType;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class UserControlPartTextBuilder implements ITextBuilderPart{

    private ScdModel scd;
    public UserControlPartTextBuilder(ScdModel scd) {
        this.scd = scd;
    }

    public String build() {
        Map<UserControlType, List<ScdModel.AccessedInputs>> perUserControl =
                this.agreggateBasedOnUserControl(scd.getAccessedInputs());

        StringBuilder userControlPart = new StringBuilder();
        List<ScdModel.AccessedInputs> noControlSensors = perUserControl.get(UserControlType.C3);

        if (noControlSensors.size() > 0) {
            userControlPart.append("\nYou do not have control when data is queried or how often, ");
            if (noControlSensors.size() > 1) {
                userControlPart.append("for the following: ");
                for (int i = 0; i < noControlSensors.size(); ++i) {
                    userControlPart.append(InputType.valueOf(noControlSensors.get(i).getInputType()));
                    if (i < noControlSensors.size() - 1) {
                        userControlPart.append(", ");
                    }
                    userControlPart.append(" ");
                }
                userControlPart.append(". ");
            } else {
                userControlPart.append("for the ")
                        .append(InputType.valueOf(noControlSensors.get(0).getInputType()))
                        .append(" sensor.");
            }
        }

        return userControlPart.toString();
    }

    private Map<UserControlType, List<ScdModel.AccessedInputs>> agreggateBasedOnUserControl(List<ScdModel.AccessedInputs> accessedInputs) {
        Map<UserControlType, List<ScdModel.AccessedInputs>> result = new TreeMap<>();

        result.put(UserControlType.C1, new ArrayList<ScdModel.AccessedInputs>());
        result.put(UserControlType.C2, new ArrayList<ScdModel.AccessedInputs>());
        result.put(UserControlType.C3, new ArrayList<ScdModel.AccessedInputs>());

        for (ScdModel.AccessedInputs sensor : accessedInputs) {
            result.get(UserControlType.valueOf(sensor.getUserControl())).add(sensor);
        }
        return result;
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        textBuilderVisitor.visit(this);
    }
}
