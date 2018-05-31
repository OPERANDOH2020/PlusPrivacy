package eu.operando.feedback.view;

import android.app.AlertDialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;

import java.util.List;

import eu.operando.R;
import eu.operando.activity.BaseActivity;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.model.FeedbackDataModelImpl;
import eu.operando.feedback.presenter.FeedbackPresenter;
import eu.operando.feedback.presenter.FeedbackPresenterImpl;

import static eu.operando.feedback.view.FeedbackDialog.SUBMIT_FEEDBACK_KEY;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackActivity extends BaseActivity implements FeedbackView, FeedbackFragment.OnClickChangeFeedbackListener {

    private FeedbackPresenter presenter;
    private RecyclerView recyclerView;
    private RecyclerView.Adapter feedbackQuestionsAdapter;
    private OperandoProgressDialog progressDialog;

    private final String TAG_FRAGMENT = "feedback_fragment";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

//        DaggerMyComponent.builder().contextModule(new ContextModule(getApplicationContext())).build().inject(this);
//        DaggerMyComponent.builder().sharedPreferencesModule(new SharedPreferencesModule()).build().inject(this);
//        SharedPreferencesReader sharedPreferencesReader = new SharedPreferencesReader(this);
        presenter = new FeedbackPresenterImpl(this, new FeedbackDataModelImpl());
        initUI();
        presenter.onLoading();
    }

    private void initUI() {

        Toolbar myToolbar = (Toolbar) findViewById(R.id.feedback_toolbar);
        setSupportActionBar(myToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);

        recyclerView = (RecyclerView) findViewById(R.id.feedback_list_recycler_view);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.restoreState();
        if (feedbackQuestionsAdapter != null) {
            feedbackQuestionsAdapter.notifyDataSetChanged();
        }
    }

    @Override
    protected void onPause() {
        presenter.saveState();
        super.onPause();
    }

    @Override
    protected void onDestroy() {
//        hideProgress();
        presenter.onDestroy();
        super.onDestroy();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                presenter.onDestroy();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void initProgressDialog() {
        progressDialog = new OperandoProgressDialog(this);
        progressDialog.setMessage("Loading...");
        progressDialog.show();
    }

    public void onClickSubmit(View view) {
        presenter.submitFeedback();
    }

    @Override
    public void showProgress() {
        if (!isFinishing()) {

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    initProgressDialog();
                }
            });
        }
    }

    @Override
    public void hideProgress() {
        if (progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
    }

    @Override
    public void setItems(final List<FeedbackQuestionEntity> items, final FeedbackSubmitEntitty feedbackSubmitEntitty) {

        recyclerView.post(new Runnable() {
            @Override
            public void run() {
                feedbackQuestionsAdapter = new FeedbackQuestionsAdapter(items, getApplicationContext(), feedbackSubmitEntitty);
                recyclerView.setAdapter(feedbackQuestionsAdapter);
                progressDialog.dismiss();
            }
        });

    }

    @Override
    public void showMessageForSubmittedFeedback(String message) {

        DialogFragment newFragment = new FeedbackDialog();

        Bundle bundle = new Bundle();
        bundle.putString(SUBMIT_FEEDBACK_KEY, message);
        newFragment.setArguments(bundle);

        newFragment.show(getFragmentManager(), "FeedbackDialog");
    }

    public void showMessageForErrorOnSubmit(String message) {

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.feedback)
                .setMessage(message)
                .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });
        builder.create().show();
    }

    @Override
    public void installFeedbackFragment() {

        recyclerView.post(new Runnable() {
            @Override
            public void run() {
                FeedbackFragment firstFragment = new FeedbackFragment();

                getSupportFragmentManager()
                        .beginTransaction()
                        .add(R.id.feedback_frame_content, firstFragment, TAG_FRAGMENT)
                        .commit();
                findViewById(R.id.feedback_frame_content).setBackgroundColor(
                        ContextCompat.getColor(getApplicationContext(), R.color.main_background));
            }
        });
    }

    @Override
    public void uninstallFeedbackFragment() {
        Fragment fragment = getSupportFragmentManager().findFragmentByTag(TAG_FRAGMENT);
        if (fragment != null)
            getSupportFragmentManager().beginTransaction().remove(fragment).commit();
        findViewById(R.id.feedback_frame_content).setBackgroundColor(
                ContextCompat.getColor(this, R.color.transparent));
    }

    @Override
    public void onClickChangeFeedbackResponse() {
        presenter.onClickChangeFeedbackResponse();
    }
}