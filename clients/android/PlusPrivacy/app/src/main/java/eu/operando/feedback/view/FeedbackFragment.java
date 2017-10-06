package eu.operando.feedback.view;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import eu.operando.R;

/**
 * Created by Matei_Alexandru on 02.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackFragment extends android.support.v4.app.Fragment{

    private ViewGroup rootView;
    private Button button;
    OnClickChangeFeedbackListener mCallback;

    public interface OnClickChangeFeedbackListener{
        void onClickChangeFeedbackResponse();
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        mCallback = (OnClickChangeFeedbackListener) activity;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        rootView = (ViewGroup) inflater.inflate(R.layout.fragment_has_submitted_feedback, container, false);
        button = (Button) rootView.findViewById(R.id.fragment_feedback_change_response);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                getFragmentManager().beginTransaction().remove(FeedbackFragment.this).commit();
                mCallback.onClickChangeFeedbackResponse();
            }
        });

        return rootView;
    }
}
