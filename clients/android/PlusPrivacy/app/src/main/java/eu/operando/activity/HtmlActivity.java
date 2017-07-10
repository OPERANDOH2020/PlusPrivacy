package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;

import eu.operando.R;

public class HtmlActivity extends BaseActivity {

    public static void start(Context context, String assetFile, String title) {
        Intent starter = new Intent(context, HtmlActivity.class);
        starter.putExtra("asset_file",assetFile);
        starter.putExtra("title",title);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
        ((WebView) findViewById(R.id.about_wv)).loadUrl(getIntent().getStringExtra("asset_file"));
    }
}
