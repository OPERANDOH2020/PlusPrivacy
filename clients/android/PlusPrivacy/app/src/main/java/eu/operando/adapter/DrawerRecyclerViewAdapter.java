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

import eu.operando.R;

/**
 * Created by Matei_Alexandru on 01.11.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class DrawerRecyclerViewAdapter extends RecyclerView.Adapter<DrawerRecyclerViewAdapter.ViewHolder> {

    private IDrawerClickCallback callback;
    private Context context;
    private String[] mDataset;
    int[] icons = new int[]{
            R.drawable.ic_info,
            R.drawable.ic_privacy,
            R.drawable.ic_settings,
            R.drawable.ic_feedback
    };

    public DrawerRecyclerViewAdapter(Context context) {
        this.context = context;
        this.callback = (IDrawerClickCallback) context;
        mDataset = context.getResources().getStringArray(R.array.drawer_items);
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
        holder.iv.setImageDrawable(ContextCompat.getDrawable(context, icons[position]));
        holder.tv.setText(mDataset[position]);
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                callback.selectItem(position);
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
        return mDataset.length;
    }


    @Override
    public int getItemViewType(int position) {
//        if (position == 0) return 0;
//        else return 1;
        return position;
    }

    public interface IDrawerClickCallback {
        void selectItem(int index);
    }
}