package eu.operando.adapter;

import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.SpinnerAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.activity.CreateIdentityActivity;
import eu.operando.osdk.swarm.client.models.Domain;

/**
 * Created by Edy on 10/20/2016.
 */
public class DomainAdapter extends ArrayAdapter<Domain> {
    public DomainAdapter(CreateIdentityActivity context, int i, ArrayList<Domain> domains) {
        super(context, i, domains);

    }

    @NonNull
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null){
            convertView = LayoutInflater.from(getContext()).inflate(android.R.layout.simple_spinner_item,parent,false);
        }
        ((TextView) convertView.findViewById(android.R.id.text1)).setText(getItem(position).getName());
        return convertView;
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {

        if(convertView == null){
            convertView = LayoutInflater.from(getContext()).inflate(android.R.layout.simple_spinner_item,parent,false);
        }
        ((TextView) convertView.findViewById(android.R.id.text1)).setText(getItem(position).getName());
        return convertView;
    }
}
