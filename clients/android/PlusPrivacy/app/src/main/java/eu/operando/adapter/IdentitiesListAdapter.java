package eu.operando.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.models.Identity;

/**
 * Created by Edy on 10/19/2016.
 */
public class IdentitiesListAdapter extends ArrayAdapter<Identity> {
    public IdentitiesListAdapter(Context context, ArrayList<Identity> identities) {
        super(context,0,identities);
    }

    @NonNull
    @Override
    public View getView(int position, View convertView, @NonNull ViewGroup parent) {
        Holder holder;
        if(convertView == null){
            holder = new Holder();
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.identity_list_item,parent,false);
            holder.defaultIV = convertView.findViewById(R.id.default_identity_iv);
            holder.emailTV = ((TextView) convertView.findViewById(R.id.identity_email_tv));
            convertView.setTag(holder);

        } else {
            holder = ((Holder) convertView.getTag());
        }
        holder.emailTV.setText(getItem(position).getEmail());
        if(getItem(position).isDefault()){
            holder.defaultIV.setVisibility(View.VISIBLE);
            convertView.setBackgroundColor(Color.parseColor("#cb8e00"));

        } else {
            holder.defaultIV.setVisibility(View.INVISIBLE);
            convertView.setBackgroundColor(Color.parseColor("#fec742"));
        }
        return convertView;

    }
    private class Holder{
        View defaultIV;
        TextView emailTV;
    }
}
