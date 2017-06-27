package eu.operando.customView;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.util.TypedValue;
import android.widget.TextView;

import eu.operando.R;

/**
 * Created by Edy on 11/8/2016.
 */

public class OperandoProgressDialog extends ProgressDialog{
    public OperandoProgressDialog(Context context) {
        this(context, R.style.AppTheme_Dialog);
    }
    public OperandoProgressDialog(Context context,String message) {
        this(context, R.style.AppTheme_Dialog);
        setMessage(message);
    }

    private OperandoProgressDialog(Context context, int theme) {
        super(context, theme);
        setIndeterminate(true);
        setCancelable(false);
    }


}
