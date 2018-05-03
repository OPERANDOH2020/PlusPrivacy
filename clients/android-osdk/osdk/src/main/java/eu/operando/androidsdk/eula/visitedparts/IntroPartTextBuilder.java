package eu.operando.androidsdk.eula.visitedparts;

import eu.operando.androidsdk.eula.visitor.ITextBuilderVisitor;

/**
 * Created by Matei_Alexandru on 13.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class IntroPartTextBuilder implements ITextBuilderPart{

    private String appTitle;

    public IntroPartTextBuilder(String appTitle) {
        this.appTitle = appTitle;
    }

    public String build(){
        String INTRO_PART = "By using SCD_APP_TITLE you agree to the following terms of " +
                "usage of your data that may or may not affect your privacy.\n\n";
        return INTRO_PART.replace("SCD_APP_TITLE", appTitle);
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        textBuilderVisitor.visit(this);
    }
}
