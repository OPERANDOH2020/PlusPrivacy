/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy.wifi;

import android.content.Context;
import android.content.res.Resources;
import android.support.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;

import eu.operando.R;
import eu.operando.proxy.MainContext;
import eu.operando.proxy.wifi.model.WiFiData;
import eu.operando.proxy.wifi.model.WiFiDetail;
import eu.operando.proxy.wifi.scanner.UpdateNotifier;


class AccessPointsAdapter extends BaseExpandableListAdapter implements UpdateNotifier {
    private final Resources resources;
    private AccessPointsAdapterData accessPointsAdapterData;
    private AccessPointsDetail accessPointsDetail;
    private Context context;

    AccessPointsAdapter(@NonNull Context context) {
        super();
        this.context = context;
        this.resources = context.getResources();
        setAccessPointsAdapterData(new AccessPointsAdapterData());
        setAccessPointsDetail(new AccessPointsDetail(this.context));
        MainContext.INSTANCE.getScanner().addUpdateNotifier(this);
    }

    protected void setAccessPointsAdapterData(@NonNull AccessPointsAdapterData accessPointsAdapterData) {
        this.accessPointsAdapterData = accessPointsAdapterData;
    }

    protected void setAccessPointsDetail(@NonNull AccessPointsDetail accessPointsDetail) {
        this.accessPointsDetail = accessPointsDetail;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        View view = getView(convertView, parent);
        WiFiDetail wiFiDetail = (WiFiDetail) getGroup(groupPosition);
        accessPointsDetail.setView(resources, view, wiFiDetail);

        ImageView groupIndicator = (ImageView) view.findViewById(R.id.groupIndicator);
        int childrenCount = getChildrenCount(groupPosition);
        if (childrenCount > 0) {
            groupIndicator.setVisibility(View.VISIBLE);
            groupIndicator.setImageResource(isExpanded
                    ? R.drawable.ic_expand_less_black_24dp
                    : R.drawable.ic_expand_more_black_24dp);
            groupIndicator.setColorFilter(resources.getColor(R.color.icons_color));
        } else {
            groupIndicator.setVisibility(View.GONE);
        }

        return view;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        View view = getView(convertView, parent);
        WiFiDetail wiFiDetail = (WiFiDetail) getChild(groupPosition, childPosition);
        accessPointsDetail.setView(resources, view, wiFiDetail);
        view.findViewById(R.id.groupIndicator).setVisibility(View.GONE);
        return view;
    }

    @Override
    public void update(@NonNull WiFiData wiFiData) {
        accessPointsAdapterData.update(wiFiData);
        notifyDataSetChanged();
    }

    @Override
    public int getGroupCount() {
        return accessPointsAdapterData.parentsCount();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return accessPointsAdapterData.childrenCount(groupPosition);
    }

    @Override
    public Object getGroup(int groupPosition) {
        return accessPointsAdapterData.parent(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return accessPointsAdapterData.child(groupPosition, childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }

    private View getView(View convertView, ViewGroup parent) {
        View view = convertView;
        if (view == null) {
            view = MainContext.INSTANCE.getLayoutInflater().inflate(R.layout.access_points_details, parent, false);
        }
        return view;
    }

}
