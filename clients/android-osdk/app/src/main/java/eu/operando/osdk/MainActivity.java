package eu.operando.osdk;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.widget.TextView;

import eu.operando.androidsdk.eula.visitedparts.EulaTextBuilder;
import eu.operando.androidsdk.eula.visitedparts.ITextBuilderPart;
import eu.operando.androidsdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.androidsdk.eula.visitor.TextBuilderDisplayVisitor;

public class MainActivity extends AppCompatActivity {

    private TextView eulaTV;
    private final String SCD_FILE = "AppSCD.json";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        eulaTV = (TextView) findViewById(R.id.eula_tv);
        setEULA();
    }

    private void setEULA() {

        ITextBuilderVisitor visitor = new TextBuilderDisplayVisitor();
        ITextBuilderPart eulaTextBuilder = new EulaTextBuilder(getApplicationContext(), SCD_FILE);
        eulaTextBuilder.accept(visitor);

        Log.e("visitor", visitor.getResult());
        eulaTV.setText(visitor.getResult());
    }
}
