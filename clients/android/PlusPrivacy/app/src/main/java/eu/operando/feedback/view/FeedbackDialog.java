package eu.operando.feedback.view;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;

import eu.operando.R;

/**
 * Created by Matei_Alexandru on 02.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackDialog extends DialogFragment {

    public static final String SUBMIT_FEEDBACK_KEY = "SUBMIT_FEEDBACK_KEY";
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        String message = getArguments().getString(SUBMIT_FEEDBACK_KEY, "Succes");

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setTitle(R.string.feedback)
                .setMessage(message)
                .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dismiss();
                        getActivity().onBackPressed();
                    }
                });

        return builder.create();
    }
}