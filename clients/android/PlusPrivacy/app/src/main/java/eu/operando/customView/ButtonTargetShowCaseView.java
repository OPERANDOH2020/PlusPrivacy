package eu.operando.customView;

import android.graphics.Point;
import android.widget.Button;

import com.github.amlcurran.showcaseview.targets.Target;
import com.github.amlcurran.showcaseview.targets.ViewTarget;

/**
 * Created by Matei_Alexandru on 20.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class ButtonTargetShowCaseView implements Target {

    private final Button button;

    public ButtonTargetShowCaseView(Button button) {
        this.button = button;
    }

    @Override
    public Point getPoint() {
        return new ViewTarget(button).getPoint();
    }
}
