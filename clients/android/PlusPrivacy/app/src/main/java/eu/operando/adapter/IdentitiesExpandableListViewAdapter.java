package eu.operando.adapter;

import android.app.ProgressDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
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
    private HashMap<Identity, List<ExtensibleItemOptions>> listHashMap;
    private List<Identity> identities;
    private static final String DEFAULT_INDENTITY = "Default identity";
    private static final String COPY_TO_CLIPBOARD = "Copy to clipboard";
    private static final String REMOVE_IDENTITY = "Remove identity";

//    public IdentitiesExpandableListViewAdapter(Context context, List<String> listGroup, HashMap<String, List<String>> listHashMap) {
//        this.context = context;
//        this.listGroup = listGroup;
//        this.listHashMap = listHashMap;
//    }

    public IdentitiesExpandableListViewAdapter(Context context, List<Identity> identities) {
        this.context = context;
        this.identities = identities;
        listHashMap = new HashMap<>();
        for (int i = 0; i < identities.size(); ++i) {
            List<ExtensibleItemOptions> options = new ArrayList<>();
            options.add(new ExtensibleItemOptions(DEFAULT_INDENTITY, R.drawable.ic_unchecked));
            options.add(new ExtensibleItemOptions(COPY_TO_CLIPBOARD, R.drawable.ic_copy));
            options.add(new ExtensibleItemOptions(REMOVE_IDENTITY, R.drawable.ic_trash));
            listHashMap.put(identities.get(i), options);
        }
    }

    @Override
    public int getGroupCount() {
        return identities.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listHashMap.get(identities.get(groupPosition)).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return identities.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return listHashMap.get(identities.get(groupPosition)).get(childPosition);
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
        final Holder holder;
        if (convertView == null) {
            holder = new Holder();
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.group_identities_elv, null);
            holder.defaultIV = convertView.findViewById(R.id.default_identity_iv);
            holder.emailTV = ((TextView) convertView.findViewById(R.id.identity_email_tv));
            holder.copyToClipboard = (ImageView) convertView.findViewById(R.id.copy_to_clipboard);
            convertView.setTag(holder);
        } else {
            holder = ((Holder) convertView.getTag());
        }
        holder.emailTV.setText(headerTitle);
        if (((Identity) getGroup(groupPosition)).isDefault()) {
            holder.defaultIV.setVisibility(View.VISIBLE);
            convertView.setBackgroundColor(Color.parseColor("#cb8e00"));

        } else {
            holder.defaultIV.setVisibility(View.INVISIBLE);
            convertView.setBackgroundColor(Color.parseColor("#fec742"));
        }

        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        ExtensibleItemOptions option = (ExtensibleItemOptions) getChild(groupPosition, childPosition);
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.list_item_identities_elv, null);
        }
        TextView tv = (TextView) convertView.findViewById(R.id.identities_elv_list_item_tv);
        ImageView iv = (ImageView) convertView.findViewById(R.id.identities_elv_list_item_iv);

        if( ((Identity)getGroup(groupPosition)).isDefault() && option.getText().equals(DEFAULT_INDENTITY)){
            iv.setImageResource(R.drawable.ic_checked);
        } else {
            iv.setImageResource(option.getDrawable());
        }
        tv.setText(option.getText());
//        iv.setImageResource(option.getDrawable());


        convertView.setOnClickListener(new CustomOnClickListener(childPosition, groupPosition, convertView));
        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    private class Holder {
        View defaultIV;
        TextView emailTV;
        ImageView copyToClipboard;
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

    private class ExtensibleItemOptions{
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
