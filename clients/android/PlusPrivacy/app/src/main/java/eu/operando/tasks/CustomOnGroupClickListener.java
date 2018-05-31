package eu.operando.tasks;

import android.view.View;
import android.widget.ExpandableListView;
import android.widget.ImageView;

import eu.operando.R;

/**
 * Created by Alex on 12/6/2017.
 */

public class CustomOnGroupClickListener implements ExpandableListView.OnGroupClickListener {

    private int groupIndicator;
    private int collapsedDrawable;
    private int groupExpandedDrawable;

    public CustomOnGroupClickListener(int groupIndicator, int collapsedDrawable,
                                      int groupExpandedDrawable) {
        this.groupIndicator = groupIndicator;
        this.collapsedDrawable = collapsedDrawable;
        this.groupExpandedDrawable = groupExpandedDrawable;
    }

    @Override
    public boolean onGroupClick(ExpandableListView parent, View clickedView, int groupPosition,
                                long l) {

        ImageView groupIndicatorIv = (ImageView) clickedView.findViewById(groupIndicator);
        if (parent.isGroupExpanded(groupPosition)) {
            parent.collapseGroup(groupPosition);
            groupIndicatorIv.setImageResource(collapsedDrawable);
        } else {
            parent.expandGroup(groupPosition);
            groupIndicatorIv.setImageResource(groupExpandedDrawable);
        }
        return true;
    }
}
