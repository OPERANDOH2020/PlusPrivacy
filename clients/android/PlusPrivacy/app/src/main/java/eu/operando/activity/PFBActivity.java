package eu.operando.activity;

import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;

import com.joanzapata.android.BaseAdapterHelper;
import com.joanzapata.android.QuickAdapter;

import java.util.List;

import eu.operando.R;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.customView.PfbCustomDialog;
import eu.operando.models.PFBObject;
import eu.operando.models.PfbDeal;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.PfbSwarmEntity;
import eu.operando.swarmclient.models.SwarmCallback;


public class PFBActivity extends BaseActivity implements PfbCustomDialog.PfbCallback {

    private SwarmService swarmService;
    private List<PFBObject> pfbs;
    private BaseAdapter adapter;
    private ListView listView;
    public static final String PFB_OBJECT = "PfbObject";
    private DialogFragment pfbCustomDialog;

    public static void start(Context context) {
        Intent starter = new Intent(context, PFBActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pfb);

        initUi();
        swarmService = SwarmService.getInstance();
        getPFB();
    }

    private void initUi() {

        initProgressDialog();
        listView = (ListView) findViewById(R.id.pfb_lv);
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }

    private void initProgressDialog() {
        ProgressDialog dialog = new OperandoProgressDialog(this);
        dialog.setMessage("Please wait...");
        dialog.setCancelable(false);
    }

    public void getPFB() {
        SwarmService.getInstance().getAllDeals(new SwarmCallback<PfbSwarmEntity>() {
            @Override
            public void call(final PfbSwarmEntity result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        pfbs = result.getDeals();

//                        for ( PFBObject pfbObject : pfbs){
//                            Log.e("PFB", pfbObject.toString());
//                        }
//                        adapter = new PfbAdapter(pfbs, getApplicationContext());
//                        listView.setAdapter(adapter);
//                        listView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));


                        adapter = new QuickAdapter<PFBObject>(PFBActivity.this, R.layout.pfb_item, pfbs) {
                            @Override
                            protected void convert(BaseAdapterHelper helper, final PFBObject item) {

                                Log.e("PFB", item.toString());
                                helper.setText(R.id.pfb_item_tv, item.getWebsite());

                                ImageView image = helper.getView(R.id.pfb_item_iv);
                                byte[] decodedString = Base64.decode(item.getLogo(), Base64.DEFAULT);
                                Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                                helper.setImageBitmap(R.id.pfb_item_iv, Bitmap.createScaledBitmap(decodedByte, 200, 200, false));


                                final CheckBox cb = helper.getView(R.id.pfb_item_cb);
                                cb.setOnCheckedChangeListener(null);
                                helper.setChecked(R.id.pfb_item_cb, item.isSubscribed());

                                cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                                    @Override
                                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                                        switchPFB(isChecked, item);
                                        item.setSubscribed(isChecked);
                                    }
                                });
                                helper.getView().setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
//                                        showDetails(item);
                                        showDialog(item);
                                    }
                                });
                            }
                        };
                        listView.setAdapter(adapter);
                    }
                });
            }
        });
    }

    @Override
    public void switchPFB(final boolean accept, final PFBObject pfbObject) {
        Log.e("DEALS", "switchPFB() called with: accept = [" + accept + "], serviceId = [" + pfbObject.getOfferId() + "]");
        SwarmService.getInstance().acceptDeal(new SwarmCallback<PfbSwarmEntity>() {
            @Override
            public void call(PfbSwarmEntity result) {

                final PfbDeal pfbDeal = result.getDeal();
                Log.e("switchPFB", pfbDeal.toString());
                pfbObject.setVoucher(pfbDeal.getVoucher());

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        refreshVoucher(pfbDeal.getVoucher(), accept);
                        adapter.notifyDataSetChanged();
                    }
                });
            }
        }, accept, pfbObject.getOfferId());
    }

    public void showDialog(PFBObject item) {
        pfbCustomDialog = new PfbCustomDialog();

        Log.e("showDialog", item.toString());
        Bundle bundle = new Bundle();
        bundle.putSerializable(PFB_OBJECT, item);
        pfbCustomDialog.setArguments(bundle);

        pfbCustomDialog.show(getFragmentManager(), "PfbCustomDialog");
    }

    void refreshVoucher(String voucher, boolean subscribe) {
        if (pfbCustomDialog != null) {
            ((PfbCustomDialog) pfbCustomDialog).updateVoucher(voucher, subscribe);
        }
    }

}