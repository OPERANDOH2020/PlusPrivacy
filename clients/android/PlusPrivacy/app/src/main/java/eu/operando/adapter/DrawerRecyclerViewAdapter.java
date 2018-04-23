package eu.operando.adapter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import eu.operando.R;
import eu.operando.models.DrawerItem;
import eu.operando.storage.Storage;

/**
 * Created by Matei_Alexandru on 01.11.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class DrawerRecyclerViewAdapter extends RecyclerView.Adapter<DrawerRecyclerViewAdapter.ViewHolder> {

    private IDrawerClickCallback callback;
    private Context context;
    private List<DrawerItem> items;

    public DrawerRecyclerViewAdapter(Context context) {
        this.context = context;
        this.callback = (IDrawerClickCallback) context;
        items = new ArrayList<>();

        String[] mDataset = context.getResources().getStringArray(R.array.drawer_items);
        int[] icons = new int[]{
                R.drawable.ic_account,
                R.drawable.ic_apps,
                R.drawable.ic_feedback,
                R.drawable.ic_privacy,
                R.drawable.ic_info,
        };

        for (int i = 0; i < icons.length; ++i){
            items.add(new DrawerItem(mDataset[i], icons[i], i));
        }

        if (!Storage.isUserLogged()){
            items.remove(0);
        }
    }

    public class ViewHolder extends RecyclerView.ViewHolder {

        TextView tv;
        ImageView iv;
        LinearLayout ll;
        LinearLayout separator;

        public ViewHolder(View drawItem, int itemType) {

            super(drawItem);

            tv = (TextView) drawItem.findViewById(R.id.drawer_recycler_view_item_tv);
            iv = (ImageView) drawItem.findViewById(R.id.drawer_recycler_view_item_iv);
            ll = (LinearLayout) drawItem.findViewById(R.id.drawer_recycler_view_item_ll);
            separator = (LinearLayout) drawItem.findViewById(R.id.menu_separator);
        }
    }

    @Override
    public DrawerRecyclerViewAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View itemLayout = layoutInflater.inflate(R.layout.drawer_recycler_view_item, null);
        return new ViewHolder(itemLayout, viewType);
    }

    @Override
    public void onBindViewHolder(DrawerRecyclerViewAdapter.ViewHolder holder, final int position) {

        Log.e("position", String.valueOf(position));
        holder.iv.setImageDrawable(ContextCompat.getDrawable(context, items.get(position).getDrawable()));
        holder.tv.setText(items.get(position).getTitle());
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                callback.selectMenuItem(items.get(position).getId());
            }
        };
        holder.ll.setOnClickListener(listener);

//            holder.tv.setOnClickListener(listener);
//            holder.iv.setOnClickListener(listener);

        if (position == getItemCount() - 1) {
            holder.separator.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
//        if (!Storage.isUserLogged()) {
//            return mDataset.length - 1;
//        }
        return items.size();
    }


    @Override
    public int getItemViewType(int position) {
//        if (position == 0) return 0;
//        else return 1;
        return position;
    }

    public interface IDrawerClickCallback {
        void selectMenuItem(int index);
    }
}