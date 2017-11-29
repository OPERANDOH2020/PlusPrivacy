package eu.operando.adapter;

import android.app.ProgressDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
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
import android.widget.Toast;

import java.util.List;

import eu.operando.R;
import eu.operando.activity.IdentitiesActivity;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.Identity;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Matei_Alexandru on 29.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class IdentitiesExpandableListViewAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<Identity> identities;
    private static final String DEFAULT_INDENTITY = "Default identity";
    private static final String COPY_TO_CLIPBOARD = "Copy to clipboard";
    private static final String REMOVE_IDENTITY = "Remove identity";

    public IdentitiesExpandableListViewAdapter(Context context, List<Identity> identities) {
        this.context = context;
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
            convertView = inflater.inflate(R.layout.group_identities_elv, null);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);

        } else {
            holder = ((GroupHolder) convertView.getTag());
        }

        holder.setData(headerTitle, groupPosition);

        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

//        ExtensibleItemOptions option = (ExtensibleItemOptions) getChild(groupPosition, childPosition);
        final ChildHolder holder;
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.child_identities_elv, null);
            holder = new ChildHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = ((ChildHolder) convertView.getTag());
        }

        holder.setData(childPosition, groupPosition);

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

        public GroupHolder(View itemView) {

            super(itemView);
            defaultIV = itemView.findViewById(R.id.default_identity_iv);
            emailTV = ((TextView) itemView.findViewById(R.id.identity_email_tv));
            copyToClipboard = (ImageView) itemView.findViewById(R.id.copy_to_clipboard);

        }

        public void setData(String headerTitle, int groupPosition) {
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

        public void setData(int childPosition, int groupPosition) {
//            convertView.setOnClickListener(new CustomOnClickListener(childPosition, groupPosition, convertView));
        }
    }

    private class CustomOnClickListener implements View.OnClickListener {

        private int childPosition;
        private int groupPosition;
        private View convertView;

        public CustomOnClickListener(int childPosition, int groupPosition, View convertView) {
            this.childPosition = childPosition;
            this.groupPosition = groupPosition;
            this.convertView = convertView;
        }

        @Override
        public void onClick(View v) {
            switch (childPosition) {
                case 0:
                    updateIdentity(groupPosition, "updateDefaultSubstituteIdentity");
                    break;
                case 1:
                    setClipboard();
                    break;
                case 2:
                    updateIdentity(groupPosition, "removeIdentity");
                    break;
            }
        }

        private void updateIdentity(int groupPosition, String method) {
            Identity i = identities.get(groupPosition);
            final ProgressDialog dialog = new OperandoProgressDialog(context);
            dialog.setCancelable(false);
            dialog.setMessage("Please wait...");
            dialog.show();
            SwarmClient.getInstance().startSwarm(new Swarm("identity.js", method, new Identity(i.getEmail(), null, null)), new SwarmCallback<Swarm>() {
                @Override
                public void call(Swarm result) {
                    ((IdentitiesActivity) context).getIdentities();
                    dialog.dismiss();
                }
            });
        }

        private void setClipboard() {

            ClipboardManager clipboard = (ClipboardManager)
                    convertView.getContext().getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData clip = ClipData.newPlainText("identity", identities.get(groupPosition).getEmail());
            clipboard.setPrimaryClip(clip);
            Toast.makeText(convertView.getContext(), "Identity was copied to clipboard", Toast.LENGTH_SHORT).show();

        }
    }

    private class ExtensibleItemOptions {
        private int drawable;
        private String text;

        public ExtensibleItemOptions(String text, int drawable) {
            this.drawable = drawable;
            this.text = text;
        }

        public int getDrawable() {
            return drawable;
        }

        public void setDrawable(int drawable) {
            this.drawable = drawable;
        }

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }
    }
}
