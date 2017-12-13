package eu.operando.customView;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;

import eu.operando.R;
import eu.operando.adapter.IdentitiesExpandableListViewAdapter;
import eu.operando.models.Identity;

/**
 * Created by Alex on 12/13/2017.
 */

public class RemoveIdentityDialog extends DialogFragment {

    private static final String IDENTITY_KEY = "IDENTITY_KEY";
    private Identity identity;
    private IdentitiesExpandableListViewAdapter.IdentityListener listener;

    public static RemoveIdentityDialog newInstance(Identity identity) {
        RemoveIdentityDialog f = new RemoveIdentityDialog();

        Bundle args = new Bundle();
        args.putSerializable(IDENTITY_KEY, identity);
        f.setArguments(args);

        return f;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        listener = (IdentitiesExpandableListViewAdapter.IdentityListener) context;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        identity = (Identity) getArguments().getSerializable(IDENTITY_KEY);

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        builder.setTitle(R.string.remove_identity)
                .setMessage(R.string.remove_identity_dialog_message)
                .setPositiveButton(R.string.action_yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        listener.updateIdentity(identity, "removeIdentity");
                    }
                })
                .setNegativeButton(R.string.action_no, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dismiss();
                    }
                });

        return builder.create();
    }

}