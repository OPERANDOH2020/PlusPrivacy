package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
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
        setContentView(R.layout.activity_html_render);

        setToolbar();
        ((WebView) findViewById(R.id.about_wv)).loadUrl(getIntent().getStringExtra("asset_file"));
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

}
