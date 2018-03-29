package eu.operando.adapter;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import eu.operando.R;
import eu.operando.activity.PermissionsActivity;
import eu.operando.tasks.DownloadImageTask;
import eu.operando.models.AbstractApp;
import eu.operando.models.SocialNetworkApp;
import eu.operando.utils.PermissionUtils;

/**
 * Created by Edy on 6/15/2016.
 */
public class ScannerListAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<? extends AbstractApp> list;

    public ScannerListAdapter(Context context, List<? extends AbstractApp> objects) {
        this.context = context;
        this.list = objects;
    }

    public interface RemoveAppInterface {
        void removeSocialApp(String appId);
    }

    public void removeGroupItem(String appId) {

        for (int index = 0; index < list.size(); ++index) {
            SocialNetworkApp app = (SocialNetworkApp) list.get(index);
            if (app.getAppId().equals(appId)) {
                list.remove(index);
                --index;
            }
        }
        notifyDataSetChanged();
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

        final AbstractApp groupItem = (AbstractApp) getGroup(position);
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

        final AbstractApp groupItem = (AbstractApp) getGroup(groupPosition);
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

        public void setData(final AbstractApp item) {

            viewPermission.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent i = new Intent(context, PermissionsActivity.class);
                    ArrayList<String> permissions = (ArrayList<String>) item.getPermissions();
                    if (permissions != null) {
                        sortPermissionList(permissions);
                    }

                    i.putExtra("perms", (ArrayList<String>) item.getPermissions());
//                    ((ScannerActivity) context).infoClicked();
                    context.startActivity(i);
                }
            });

            uninstallApp.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (item instanceof SocialNetworkApp) {
                        ((RemoveAppInterface) context).removeSocialApp(((SocialNetworkApp) item).getAppId());
                    } else {
                        Intent intent = new Intent(Intent.ACTION_DELETE);
                        intent.setData(Uri.parse("package:" + item.getPackageName()));
                        context.startActivity(intent);
                    }
                }
            });
        }
    }

    private void sortPermissionList(ArrayList<String> permissions) {
        Collections.sort(permissions, new Comparator<String>() {
            @Override
            public int compare(String permission1, String permission2) {
                if (PermissionUtils.getPermissionRiskScore(permission1) > PermissionUtils.getPermissionRiskScore(permission2))
                    return -1;
                else if (PermissionUtils.getPermissionRiskScore(permission1) < PermissionUtils.getPermissionRiskScore(permission2))
                    return 1;
                return 0;
            }
        });
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

        public void setData(AbstractApp item, boolean isExpanded) {

            groupIndicator.setSelected(isExpanded);
            setAppCircleIndicator(item);
            appName.setText(item.getAppName());
            String poll = "Privacy Pollution: " + item.getPollutionScore() + "/10";

            appPrivacyPolution.setText(poll);

            if (item instanceof SocialNetworkApp) {

                setSocialAppIcon(item);

            } else {

                setNativeAppIcon(item);
            }
        }

        private void setNativeAppIcon(AbstractApp item) {

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

        private void setSocialAppIcon(AbstractApp item) {

            String appIconUrl = ((SocialNetworkApp) item).getIconUrl();
            appIconUrl = appIconUrl.replace("\\", "%");
            appIconUrl = appIconUrl.replace(" ", "");

            try {
                appIconUrl = java.net.URLDecoder.decode(appIconUrl, "UTF-8");
                Log.e("appiconurl", appIconUrl);
                new DownloadImageTask(appIcon)
                        .execute(appIconUrl);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }

        private void setAppCircleIndicator(AbstractApp item) {

            GradientDrawable bgShape = (GradientDrawable) appCircleIndicator.getBackground();
            bgShape.setColor(PermissionUtils.getColor(item));

        }
    }

}
