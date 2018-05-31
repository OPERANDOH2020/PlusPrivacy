package eu.operando.androidsdk.eula.visitor;

import eu.operando.androidsdk.eula.visitedparts.AccessFrequencyPartTextBuilder;
import eu.operando.androidsdk.eula.visitedparts.DownloadDataPartTextBuilder;
import eu.operando.androidsdk.eula.visitedparts.IntroPartTextBuilder;
import eu.operando.androidsdk.eula.visitedparts.SensorPartTextBuilder;
import eu.operando.androidsdk.eula.visitedparts.UserControlPartTextBuilder;

/**
 * Created by Matei_Alexandru on 13.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface ITextBuilderVisitor {
    void visit(AccessFrequencyPartTextBuilder accessFrequencyPartTextBuilder);
    void visit(DownloadDataPartTextBuilder downloadDataPartTextBuilder);
    void visit(SensorPartTextBuilder sensorPartTextBuilder);
    void visit(UserControlPartTextBuilder userControlPartTextBuilder);
    void visit(IntroPartTextBuilder introPartTextBuilder);
    String getResult();
}
