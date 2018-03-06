package eu.operando.customView;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import eu.operando.R;

/**
 * Created by Alex on 12/28/2017.
 */

public class FacebookSettingsInfoDialog extends DialogFragment {

    ImageView closeIv;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View convertView = inflater.inflate(R.layout.dialog_facebook_settings_info, null);

        closeIv = (ImageView) convertView.findViewById(R.id.fb_dialog_close_iv);
        closeIv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
            }
        });

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setView(convertView);
        return builder.create();
    }
}