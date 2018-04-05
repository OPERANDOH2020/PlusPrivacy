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
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import eu.operando.R;
import eu.operando.activity.PermissionsActivity;
import eu.operando.activity.SocialNetworkAppsListActivity;
import eu.operando.models.AbstractApp;
import eu.operando.models.SocialNetworkApp;
import eu.operando.utils.PermissionUtils;

/**
 * Created by Edy on 6/15/2016.
 */
public class ScannerListAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<? extends AbstractApp> list;

    public interface SocialNetworkColor {
        int getSNMainColor();

        int getSNSecondaryColor();
    }

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
        RelativeLayout childItem;


        public ChildHolder(View itemView) {
            super(itemView);

            uninstallApp = itemView.findViewById(R.id.trash_btn);
            viewPermission = itemView.findViewById(R.id.eye_btn);
            childItem = (RelativeLayout) itemView.findViewById(R.id.child_item);
        }

        public void setData(final AbstractApp item) {

            if (item instanceof SocialNetworkApp) {
                childItem.setBackgroundColor(context.getResources().getColor(
                        ((SocialNetworkColor) context).getSNSecondaryColor()
                ));
                viewPermission.setBackgroundColor(context.getResources().getColor(
                        ((SocialNetworkColor) context).getSNMainColor()
                ));
                uninstallApp.setBackgroundColor(context.getResources().getColor(
                        ((SocialNetworkColor) context).getSNMainColor()
                ));
            }

            viewPermission.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent i = new Intent(context, PermissionsActivity.class);
                    ArrayList<String> permissions = (ArrayList<String>) item.getPermissions();
                    if (permissions != null) {
                        sortPermissionList(permissions);
                    }

                    i.putExtra("perms", (ArrayList<String>) item.getPermissions());
                    if (item instanceof SocialNetworkApp) {
                        i.putExtra("color", ((SocialNetworkColor) context).getSNMainColor());
                    }
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

        RelativeLayout itemRL;
        RelativeLayout itemBoxRL;
        ImageView appIcon;
        WebView appIconWv;
        TextView appName;
        TextView appPrivacyPolution;
        View appCircleIndicator;
        ImageView groupIndicator;

        public GroupHolder(View itemView) {
            super(itemView);

            itemRL = (RelativeLayout) itemView.findViewById(R.id.item_view);
            itemBoxRL = (RelativeLayout) itemView.findViewById(R.id.item_box);
            appIcon = (ImageView) itemView.findViewById(R.id.app_icon);
            appIconWv = (WebView) itemView.findViewById(R.id.app_icon_wv);
            appName = (TextView) itemView.findViewById(R.id.app_name);
            appPrivacyPolution = (TextView) itemView.findViewById(R.id.app_privacy_polution);
            appCircleIndicator = itemView.findViewById(R.id.drawable_circle_indicator);
            groupIndicator = (ImageView) itemView.findViewById(R.id.arrow);
        }

        public void setData(AbstractApp item, boolean isExpanded) {

            if (context instanceof SocialNetworkAppsListActivity) {
                itemBoxRL.setBackgroundColor(context.getResources().getColor(
                        ((SocialNetworkColor) context).getSNSecondaryColor()
                ));
            }
            groupIndicator.setSelected(isExpanded);
            setAppCircleIndicator(item);
            appName.setText(item.getAppName());

            if (item instanceof SocialNetworkApp) {

                setSocialAppIcon(item);
                if (((SocialNetworkApp) item).getPermissionGroups() != null) {
                    for (SocialNetworkApp.PermissionGroups permissionGroup : ((SocialNetworkApp) item).getPermissionGroups()) {
                        item.setPermissions(permissionGroup.getPermissions());
                    }
                }
                PermissionUtils.calculatePollutionScore(item);


            } else {

                setNativeAppIcon(item);
            }

            String poll = "Privacy Pollution: " + item.getPollutionScore() + "/10";
            appPrivacyPolution.setText(poll);
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
                if (!appIconUrl.contains("linkedin")) {
                    appIconUrl = java.net.URLDecoder.decode(appIconUrl, "UTF-8");
                }
                Log.e("appiconurl", appIconUrl);

                if (appIconUrl.endsWith("svg")) {
                    setAppIconWebView(appIconUrl);
                } else {
                    Picasso.with(context).load(appIconUrl).into(appIcon);
//                    new DownloadImageTask(appIcon)
//                        .execute(appIconUrl);
                }

            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }

        private void setAppIconWebView(String appIconURL) {

            appIconWv.setVisibility(View.VISIBLE);
            appIcon.setVisibility(View.GONE);

//            appIconWv.setInitialScale(1);
//            WebSettings settings = appIconWv.getSettings();
//            settings.setSupportZoom(true);
//            settings.setDefaultZoom(WebSettings.ZoomDensity.MEDIUM);
//            settings.setUseWideViewPort(true);
//            appIconWv.getSettings().setBuiltInZoomControls(true);
//            appIconWv.getSettings().setDisplayZoomControls(false);
            appIconWv.setVerticalScrollBarEnabled(false);
            appIconWv.setHorizontalScrollBarEnabled(false);
            appIconWv.setBackgroundColor(0x00000000);

            appIconWv.setWebViewClient(new WebViewClient() {

                public void onPageFinished(WebView view, String url) {
                    super.onPageFinished(view, url);
                    view.setVisibility(View.VISIBLE);
                }
            });
            appIconWv.loadUrl(appIconURL);
        }

        private void setAppCircleIndicator(AbstractApp item) {

            GradientDrawable bgShape = (GradientDrawable) appCircleIndicator.getBackground();
            bgShape.setColor(PermissionUtils.getColor(item));

        }
    }

}
