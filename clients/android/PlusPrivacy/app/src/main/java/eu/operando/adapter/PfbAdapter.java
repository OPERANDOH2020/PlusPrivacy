package eu.operando.adapter;

import android.content.Context;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.models.PFBObject;

/**
 * Created by Matei_Alexandru on 04.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class PfbAdapter extends RecyclerView.Adapter<PfbAdapter.PFBViewHolder> {

//    interface IMethodCaller{
//        void switchPFB(boolean accept, int serviceId);
//    }

    private List<PFBObject> items;
    private Context context;

    public PfbAdapter(List<PFBObject> items, Context context) {
        this.items = items;
        this.context = context;
    }

    @Override
    public PFBViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.pfb_item, parent, false);
        return new PFBViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(PFBViewHolder holder, int position) {

        final PFBObject item = items.get(position);

        Log.e("PFB", item.toString());

        holder.textView.setText(item.getWebsite());

        Uri imgUri = Uri.parse(item.getLogo());
        holder.imageView.setImageURI(null);
        holder.imageView.setImageURI(imgUri);

        holder.checkedBox.setOnCheckedChangeListener(null);
        holder.checkedBox.setChecked(item.isSubscribed());

        holder.checkedBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//                ((IMethodCaller)context).switchPFB(isChecked, item.getOfferId());
            }
        });

//        helper.getView().setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                showDetails(item);
//            }
//        });
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    class PFBViewHolder extends RecyclerView.ViewHolder {

        ImageView imageView;
        TextView textView;
        CheckBox checkedBox;

        private PFBViewHolder(View itemView) {
            super(itemView);
            imageView = (ImageView) itemView.findViewById(R.id.pfb_item_iv);
            textView = (TextView) itemView.findViewById(R.id.pfb_item_tv);
            checkedBox = (CheckBox) itemView.findViewById(R.id.pfb_item_cb);
        }
    }
}
