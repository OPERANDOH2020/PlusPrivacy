package eu.operando.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.joanzapata.android.BaseAdapterHelper;
import com.joanzapata.android.QuickAdapter;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import eu.operando.R;
import eu.operando.adapter.SensorsListAdapter;
import eu.operando.model.SensorModel;
import eu.operando.osdk.swarm.client.SwarmClient;
import eu.operando.osdk.swarm.client.events.DealResultEvent;
import eu.operando.osdk.swarm.client.events.PFBListEvent;
import eu.operando.osdk.swarm.client.models.PFBObject;
import eu.operando.util.SensorUtils;


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
        dialog = new ProgressDialog(this);
        dialog.setMessage("Please wait...");
        dialog.setCancelable(false);
        try {
            swarmClient = SwarmClient.getInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        lv = (ListView) findViewById(R.id.pfb_lv);
        getPFB();
    }


    public void getPFB() {
        swarmClient.startSwarm("pfb.js", "start", "getAllDeals");
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onPFBList(PFBListEvent event) {
        pfbs = event.getPfbs();
        Log.d("PFBActivity", "onPFBList() called with: event = [" + event + "]");
        adapter = new QuickAdapter<PFBObject>(this, R.layout.pfb_item, pfbs) {
            @Override
            protected void convert(BaseAdapterHelper helper, final PFBObject item) {
                helper.setText(R.id.tv, item.getWebsite());
                helper.setImageUrl(R.id.iv, item.getLogo());
                helper.setChecked(R.id.cb, item.isSubscribed());
                final CheckBox cb = helper.getView(R.id.cb);
                cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (isChecked) {
                            swarmClient.startSwarm("pfb.js", "start", "acceptDeal", new String[]{item.getServiceId() + ""});
                        } else {
                            swarmClient.startSwarm("pfb.js", "start", "unsubscribeDeal", new String[]{item.getServiceId() + ""});
                        }
                    }
                });

                helper.getView().setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        showDetails(item);
                    }
                });
            }
        };

        lv.setAdapter(adapter);

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
                            swarmClient.startSwarm("pfb.js", "start", "acceptDeal", new String[]{pfbObject.getServiceId() + ""});
                            voucher_benefit.setText("Voucher");
                            voucher_benefit_content.setText(pfbObject.getVoucher());
                        } else {
                            swarmClient.startSwarm("pfb.js", "start", "unsubscribeDeal", new String[]{pfbObject.getServiceId() + ""});
                            voucher_benefit.setText("Benefit");
                            voucher_benefit_content.setText(pfbObject.getBenefit());
                        }
                    }
                });
            }
        }.show();
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onDealResult(DealResultEvent event) {
    }
}
