package eu.operando.osdk.eula.visitor;

import eu.operando.osdk.eula.visitedparts.AccessFrequencyPartTextBuilder;
import eu.operando.osdk.eula.visitedparts.DownloadDataPartTextBuilder;
import eu.operando.osdk.eula.visitedparts.IntroPartTextBuilder;
import eu.operando.osdk.eula.visitedparts.SensorPartTextBuilder;
import eu.operando.osdk.eula.visitedparts.UserControlPartTextBuilder;

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
