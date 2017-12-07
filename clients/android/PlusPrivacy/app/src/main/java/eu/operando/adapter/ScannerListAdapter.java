package eu.operando.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.DrawableContainer;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.activity.PermissionsActivity;
import eu.operando.activity.ScannerActivity;
import eu.operando.models.InstalledApp;
import eu.operando.utils.PermissionUtils;

/**
 * Created by Edy on 6/15/2016.
 */
public class ScannerListAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<InstalledApp> list;

    public ScannerListAdapter(Context context, List<InstalledApp> objects) {
        this.context = context;
        this.list = objects;
    }

    @Override
    public int getGroupCount() {
        return list.size();
    }

    @Override
    public int getChildrenCount(int i) {
        return 1;
    }

    @Override
    public Object getGroup(int i) {
        return list.get(i);
    }

    @Override
    public Object getChild(int i, int i1) {
        return list.get(i);
    }

    @Override
    public long getGroupId(int i) {
        return i;
    }

    @Override
    public long getChildId(int i, int i1) {
        return i + i1;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int position, boolean isExpanded, View convertView, ViewGroup viewGroup) {
        final GroupHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.scanner_list_item, null);

            holder = new GroupHolder(convertView);

            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }

        final InstalledApp groupItem = (InstalledApp) getGroup(position);
        holder.setData(groupItem, isExpanded);

        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild,
                             View convertView, ViewGroup viewGroup) {

        final ChildHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater)
                    context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.scanner_list_child_item, null);

            holder = new ChildHolder(convertView);

            convertView.setTag(holder);
        } else {
            holder = (ChildHolder) convertView.getTag();
        }

        final InstalledApp groupItem = (InstalledApp) getGroup(groupPosition);
        holder.setData(groupItem);

        return convertView;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return false;
    }

    private class ChildHolder extends RecyclerView.ViewHolder {

        View uninstallApp;
        View viewPermission;


        public ChildHolder(View itemView) {
            super(itemView);

            uninstallApp = itemView.findViewById(R.id.trash_btn);
            viewPermission = itemView.findViewById(R.id.eye_btn);
        }

        public void setData(final InstalledApp item) {

            viewPermission.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent i = new Intent(context, PermissionsActivity.class);
                    i.putExtra("perms", item.getPermissions());
                    ((ScannerActivity) context).infoClicked();
                    context.startActivity(i);
                }
            });

            uninstallApp.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(Intent.ACTION_DELETE);
                    intent.setData(Uri.parse("package:" + item.getPackageName()));
                    context.startActivity(intent);
                }
            });
        }
    }

    private class GroupHolder extends RecyclerView.ViewHolder {

        ImageView appIcon;
        TextView appName;
        TextView appPrivacyPolution;
        View appCircleIndicator;
        ImageView groupIndicator;

        public GroupHolder(View itemView) {
            super(itemView);

            appIcon = (ImageView) itemView.findViewById(R.id.app_icon);
            appName = (TextView) itemView.findViewById(R.id.app_name);
            appPrivacyPolution = (TextView) itemView.findViewById(R.id.app_privacy_polution);
            appCircleIndicator = itemView.findViewById(R.id.drawable_circle_indicator);
            groupIndicator = (ImageView) itemView.findViewById(R.id.arrow);
        }

        public void setData(InstalledApp item, boolean isExpanded) {

            groupIndicator.setSelected(isExpanded);
            setAppCircleIndicator(item);
            appName.setText(item.getAppName());
            String poll = "Privacy Pollution: " + item.getPollutionScore() + "/10";

            appPrivacyPolution.setText(poll);
            Drawable d = null;
            try {
                d = context.getPackageManager().getApplicationIcon(item.getPackageName());
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            if (d != null) {
                appIcon.setImageDrawable(d);
            }
        }

        private void setAppCircleIndicator(InstalledApp item) {

            GradientDrawable bgShape = (GradientDrawable)appCircleIndicator.getBackground();
            bgShape.setColor(PermissionUtils.getColor(item));

        }

    }

}
