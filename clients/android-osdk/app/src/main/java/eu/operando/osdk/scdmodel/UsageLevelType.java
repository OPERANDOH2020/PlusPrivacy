package eu.operando.osdk.scdmodel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public enum UsageLevelType {
    LocalOnly(1),
    AggregateOnly(2),
    DPCompatible(3),
    SelfUseOnly(4),
    SharedWithThirdParty(5),
    Unspecified(6);

    private int level;

    UsageLevelType(int level) {
        this.level = level;
    }

    public int getLevel() {
        return level;
    }
}
