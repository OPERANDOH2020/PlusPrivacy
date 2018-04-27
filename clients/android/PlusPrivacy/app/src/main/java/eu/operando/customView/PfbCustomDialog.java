package eu.operando.customView;

import android.app.Dialog;
import android.app.DialogFragment;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.models.PFBObject;

import static eu.operando.activity.PFBActivity.PFB_OBJECT;

/**
 * Created by Matei_Alexandru on 05.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class PfbCustomDialog extends DialogFragment {

    ImageView image;
    TextView voucher_benefit;
    TextView voucher_benefit_content;
    CheckBox subscribeCB;
    PFBObject pfbObject;
    PfbCallback callback;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        callback = (PfbCallback) getActivity();
        pfbObject = (PFBObject) getArguments().getSerializable(PFB_OBJECT);

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View convertView = inflater.inflate(R.layout.dialog_pfb_details, null);

        image = (ImageView) convertView.findViewById(R.id.pfb_item_iv);
        voucher_benefit = ((TextView) convertView.findViewById(R.id.voucher_benefit));
        voucher_benefit_content = ((TextView) convertView.findViewById(R.id.voucher_benefit_content));
        subscribeCB = ((CheckBox) convertView.findViewById(R.id.subscribeCB));
        ((TextView) convertView.findViewById(R.id.description)).setText(pfbObject.getDescription());

//        Log.e("PFFB2", pfbObject.getVoucher());

        setImageForPFB();
        setDialogInformations(pfbObject.isSubscribed());

        subscribeCB.setOnCheckedChangeListener(null);
        subscribeCB.setChecked(pfbObject.isSubscribed());

        subscribeCB.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    callback.switchPFB(true, pfbObject);
                } else {
                    callback.switchPFB(false, pfbObject);
                }
                pfbObject.setSubscribed(isChecked);
            }
        });

        android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(getActivity());
        builder.setView(convertView);
        return builder.create();
    }

    private void setDialogInformations(boolean subscribed) {
        if (subscribed) {
            voucher_benefit.setText("Voucher");
            Log.e("PFFB", pfbObject.toString());
            voucher_benefit_content.setText(pfbObject.getVoucher());
        } else {
            voucher_benefit.setText("Benefit");
            voucher_benefit_content.setText("");
        }
    }

    private void setImageForPFB() {

        byte[] decodedString = Base64.decode(pfbObject.getLogo(), Base64.DEFAULT);
        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
        image.setImageBitmap(Bitmap.createScaledBitmap(decodedByte, 200, 200, false));
    }

    public void updateVoucher(String voucher, boolean subscribe) {
        pfbObject.setVoucher(voucher);
        setDialogInformations(subscribe);
    }

    public interface PfbCallback {
        void switchPFB(boolean accept, PFBObject pfbObject);
    }
}