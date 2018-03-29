package eu.operando.tasks;

import android.widget.ExpandableListView;

/**
 * Created by Alex on 12/6/2017.
 */

public class AccordionOnGroupExpandListener implements ExpandableListView.OnGroupExpandListener{

    private ExpandableListView elv;
    private int previousGroup = -1;

    public AccordionOnGroupExpandListener(ExpandableListView elv) {
        this.elv = elv;
    }

    @Override
    public void onGroupExpand(int groupPosition) {
        if (groupPosition != previousGroup)
            elv.collapseGroup(previousGroup);
        previousGroup = groupPosition;
    }
}
