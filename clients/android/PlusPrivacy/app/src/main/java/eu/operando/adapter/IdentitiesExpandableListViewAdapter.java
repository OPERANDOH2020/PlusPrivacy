package eu.operando.adapter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.models.Identity;

/**
 * Created by Matei_Alexandru on 29.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class IdentitiesExpandableListViewAdapter extends BaseExpandableListAdapter {

    private Context context;
    private IdentityListener listener;
    private List<Identity> identities;
    private static final String DEFAULT_INDENTITY = "Default identity";
    private static final String COPY_TO_CLIPBOARD = "Copy to clipboard";
    private static final String REMOVE_IDENTITY = "Remove identity";

    public IdentitiesExpandableListViewAdapter(Context context, List<Identity> identities) {
        this.context = context;
        listener = (IdentityListener) context;
        this.identities = identities;
    }

    @Override
    public int getGroupCount() {
        return identities.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return 1;
    }

    @Override
    public Object getGroup(int groupPosition) {
        return identities.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return identities.get(groupPosition);
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
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {

        String headerTitle = ((Identity) getGroup(groupPosition)).getEmail();
        final GroupHolder holder;
        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.identities_group_item, null);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);

        } else {
            holder = ((GroupHolder) convertView.getTag());
        }

        holder.setData(headerTitle, groupPosition, isExpanded);

        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

//        ExtensibleItemOptions option = (ExtensibleItemOptions) getChild(groupPosition, childPosition);
        final ChildHolder holder;
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.identities_child_item, null);
            holder = new ChildHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = ((ChildHolder) convertView.getTag());
        }

        Identity identity = identities.get(groupPosition);
        holder.setData(identity);

        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    private class GroupHolder extends RecyclerView.ViewHolder {

        View defaultIV;
        TextView emailTV;
        ImageView copyToClipboard;
        ImageView groupIndicator;

        public GroupHolder(View itemView) {

            super(itemView);
            defaultIV = itemView.findViewById(R.id.default_identity_iv);
            emailTV = ((TextView) itemView.findViewById(R.id.identity_email_tv));
            copyToClipboard = (ImageView) itemView.findViewById(R.id.copy_to_clipboard);
            groupIndicator = (ImageView) itemView.findViewById(R.id.arrow);
        }

        public void setData(String headerTitle, int groupPosition, boolean isExpanded) {
            groupIndicator.setSelected(isExpanded);
            emailTV.setText(headerTitle);
            if (((Identity) getGroup(groupPosition)).isDefault()) {

                defaultIV.setBackground(ContextCompat.getDrawable(context, R.drawable.default_enabled));
            } else {
                defaultIV.setBackground(ContextCompat.getDrawable(context, R.drawable.default_disabled));
            }
        }
    }

    private class ChildHolder extends RecyclerView.ViewHolder {

        LinearLayout makeDefault;
        LinearLayout copyToClipboard;
        LinearLayout removeIdentity;

        public ChildHolder(View itemView) {

            super(itemView);
            makeDefault = (LinearLayout) itemView.findViewById(R.id.make_default);
            copyToClipboard = (LinearLayout) itemView.findViewById(R.id.copy_to_clipboard);
            removeIdentity = (LinearLayout) itemView.findViewById(R.id.remove_identity);

        }

        public void setData(final Identity identity) {
            makeDefault.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    listener.updateIdentity(identity, "updateDefaultSubstituteIdentity");
                }
            });

            removeIdentity.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    listener.updateIdentity(identity, "removeIdentity");
                }
            });

            copyToClipboard.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    listener.setClipboard(identity);
                }
            });
        }
    }

    public interface IdentityListener {
        void updateIdentity(Identity identity, String method);

        void setClipboard(Identity identity);
    }
}
