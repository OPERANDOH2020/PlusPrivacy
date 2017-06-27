package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.joanzapata.android.BaseAdapterHelper;
import com.joanzapata.android.QuickAdapter;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.PFBObject;
import eu.operando.swarmService.models.GetPFBSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;


public class PFBActivity extends BaseActivity {

    private SwarmClient swarmClient;
    private ArrayList<PFBObject> pfbs;
    private BaseAdapter adapter;
    private ProgressDialog dialog;

    public static void start(Context context) {
        Intent starter = new Intent(context, PFBActivity.class);
        context.startActivity(starter);
    }

    SensorManager sensorManager;
    ListView lv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pfb);
        dialog = new OperandoProgressDialog(this);
        dialog.setMessage("Please wait...");
        dialog.setCancelable(false);
        swarmClient = SwarmClient.getInstance();

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        lv = (ListView) findViewById(R.id.pfb_lv);
        getPFB();
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }


    public void getPFB() {
//        swarmClient.startSwarm(new GetPFBSwarm(), new SwarmCallback<GetPFBSwarm>() {
//
//            @Override
//            public void call(final GetPFBSwarm result) {
//                runOnUiThread(new Runnable() {
//                    @Override
//                    public void run() {
//                        pfbs = result.getDeals();
//                        adapter = new QuickAdapter<PFBObject>(PFBActivity.this, R.layout.pfb_item, pfbs) {
//                            @Override
//                            protected void convert(BaseAdapterHelper helper, final PFBObject item) {
//                                helper.setText(R.id.tv, item.getWebsite());
//                                helper.setImageUrl(R.id.iv, item.getLogo());
//                                ((CheckBox) helper.getView(R.id.cb)).setOnCheckedChangeListener(null);
//                                helper.setChecked(R.id.cb, item.isSubscribed());
//                                final CheckBox cb = helper.getView(R.id.cb);
//                                cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
//                                    @Override
//                                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//                                        switchPFB(isChecked, item.getServiceId());
//                                    }
//                                });
//
//                                helper.getView().setOnClickListener(new View.OnClickListener() {
//                                    @Override
//                                    public void onClick(View v) {
//                                        showDetails(item);
//                                    }
//                                });
//                            }
//                        };
//
//                        lv.setAdapter(adapter);
//                    }
//                });
//            }
//        });


    }

    private void switchPFB(boolean accept, int serviceId) {
        Log.e("DEALS", "switchPFB() called with: accept = [" + accept + "], serviceId = [" + serviceId + "]");
        swarmClient.startSwarm(new Swarm("pfb.js", accept ? "acceptDeal" : "unsubscribeDeal", serviceId), null);
    }

    private void showDetails(final PFBObject pfbObject) {
        new AlertDialog(this) {
            @Override
            protected void onCreate(Bundle savedInstanceState) {
                super.onCreate(savedInstanceState);
                setContentView(R.layout.dialog_pfb_details);
                Picasso.with(getContext())
                        .load(pfbObject.getLogo())
                        .into(((ImageView) findViewById(R.id.iv)), new Callback() {
                            @Override
                            public void onSuccess() {

                            }

                            @Override
                            public void onError() {

                            }
                        });
                final TextView voucher_benefit = ((TextView) findViewById(R.id.voucher_benefit));
                voucher_benefit.setText(pfbObject.isSubscribed() ? "Voucher" : "Benefit");
                final TextView voucher_benefit_content = ((TextView) findViewById(R.id.voucher_benefit_content));
                voucher_benefit_content.setText(pfbObject.isSubscribed() ? pfbObject.getVoucher() : pfbObject.getBenefit());
                ((TextView) findViewById(R.id.description)).setText(pfbObject.getDescription());
                CheckBox subscribeCB = ((CheckBox) findViewById(R.id.subscribeCB));
                subscribeCB.setChecked(pfbObject.isSubscribed());
                subscribeCB.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            switchPFB(true, pfbObject.getServiceId());
                            voucher_benefit.setText("Voucher");
                            voucher_benefit_content.setText(pfbObject.getVoucher());
                        } else {
                            switchPFB(false, pfbObject.getServiceId());
                            voucher_benefit.setText("Benefit");
                            voucher_benefit_content.setText(pfbObject.getBenefit());
                        }
                    }
                });
            }
        }.show();
    }

}
