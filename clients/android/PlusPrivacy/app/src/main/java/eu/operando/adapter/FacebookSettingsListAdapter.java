package eu.operando.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.ColorStateList;
import android.os.Build;
import android.support.annotation.IdRes;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.AppCompatRadioButton;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import eu.operando.R;
import eu.operando.models.privacysettings.AvailableSettings;
import eu.operando.models.privacysettings.Question;

/**
 * Created by Matei_Alexandru on 01.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookSettingsListAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<Question> questions;
    private Map<Integer, Integer> checkedState;
    private Map<Integer, Integer> recommended;
    private final String FACEBOOK_PREFS = "FACEBOOK_PREFS";

    public FacebookSettingsListAdapter(Context context, List<Question> questions, Map<Integer, Integer> checkedList) {
        this.context = context;
        this.questions = questions;
        this.checkedState = checkedList;
        getRecommendedValues();
//        initCheckedState();
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public Map<Integer, Integer> getCheckedState() {
        return checkedState;
    }

    private void initCheckedState() {

        this.checkedState = new HashMap<>();
        SharedPreferences settings = context.getSharedPreferences(FACEBOOK_PREFS, 0);
        String fbPrefStr = settings.getString(FACEBOOK_PREFS, "");

        if (fbPrefStr.equals("")) {
            initCheckedStateFromRecommendedValues();
        } else {
            initCheckedStateFromSharedPreferences(fbPrefStr);
        }
    }

    private void initCheckedStateFromSharedPreferences(String fbPrefStr) {

        try {
            JSONArray fbPrefJson = new JSONArray(fbPrefStr);
            for (int i = 0; i < fbPrefJson.length(); ++i) {
                checkedState.put(i, fbPrefJson.getInt(i));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.e("initCheckedStateSF", fbPrefStr);
    }

    public void getRecommendedValues() {

        recommended = new HashMap<>();
        for (int i = 0; i < questions.size(); ++i) {
            List<AvailableSettings> options = questions.get(i).getRead().getAvailableSettings();
            for (int j = 0; j < options.size(); ++j) {
                if (options.get(j).getTag().equals(questions.get(i).getWrite().getRecommended())) {
                    recommended.put(i, j);
                }
            }
        }
    }

    public void initCheckedStateFromRecommendedValues() {

        checkedState = new HashMap<>(recommended);
        notifyDataSetChanged();
        Log.e("initCheckedStateRV", String.valueOf(checkedState));
    }

    public void saveCheckedStateInSharedPrefs() {
        Log.e("saveCheckedState", checkedState.values().toString());

        SharedPreferences settings = context.getSharedPreferences(FACEBOOK_PREFS, 0);
        SharedPreferences.Editor editor = settings.edit();

        JSONArray fbPrefJson = new JSONArray();

        for (Map.Entry<Integer, Integer> entry : checkedState.entrySet()) {
            try {
                fbPrefJson.put(entry.getKey(), (Object) entry.getValue());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        editor.putString(FACEBOOK_PREFS, fbPrefJson.toString());
        editor.apply();
    }

    @Override
    public int getGroupCount() {
        return questions.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return 1;
    }

    @Override
    public Object getGroup(int groupPosition) {
        return questions.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return questions.get(groupPosition).getRead().getAvailableSettings();
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {

        final GroupHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.group_questions_elv, null);
            holder = new GroupHolder(convertView);

            convertView.setTag(holder);
        } else {
            holder = ((GroupHolder) convertView.getTag());
        }
        holder.setData(groupPosition);
        return convertView;
    }

    @SuppressLint("RestrictedApi")
    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        final ChildViewHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.list_item_answers_osp_elv, null);
            holder = new ChildViewHolder(convertView);

            convertView.setTag(holder);

        } else {
            holder = ((ChildViewHolder) convertView.getTag());
            holder.questionsRG.removeAllViews();
        }

        holder.setData(groupPosition, (List<AvailableSettings>) getChild(groupPosition, childPosition));

        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    private class GroupHolder extends RecyclerView.ViewHolder {

        ImageView recommendedIcon;
        TextView questionTV;

        GroupHolder(View itemView) {
            super(itemView);

            questionTV = ((TextView) itemView.findViewById(R.id.question_tv));
            recommendedIcon = (ImageView) itemView.findViewById(R.id.recommended_icon);
        }

        public void setData(int groupPosition){
            String questionText = ((Question) getGroup(groupPosition)).getRead().getName();
            questionTV.setText(questionText);

            if (recommended.get(groupPosition).equals(checkedState.get(groupPosition))){
                recommendedIcon.setVisibility(View.VISIBLE);
            } else {
                recommendedIcon.setVisibility(View.INVISIBLE);
            }
        }
    }

    private class ChildViewHolder extends RecyclerView.ViewHolder {
        RadioGroup questionsRG;

        public ChildViewHolder(View itemView) {
            super(itemView);

            questionsRG = (RadioGroup) itemView.findViewById(R.id.layout_list_item_answer);
        }

        @SuppressLint("RestrictedApi")
        public void setData(final int groupPosition, List<AvailableSettings> answerList){

            for (int i = 0; i < answerList.size(); i++) {
                int answerIndex = checkedState.get(groupPosition);
                Log.e("answerIndex", String.valueOf(answerIndex));
                AppCompatRadioButton rb = new AppCompatRadioButton(context);

                rb.setText(answerList.get(i).getName());
                rb.setTextColor(context.getResources().getColor(R.color.white));
                rb.setSupportButtonTintList(ContextCompat.getColorStateList(context, R.color.facebook_selected));
                int id = View.generateViewId();
                rb.setId(id);
                if (answerIndex == i) {
                    rb.setChecked(true);
                    questionsRG.check(id);
                }
                if (recommended.get(groupPosition) == i ) {
                    rb.setSupportButtonTintList(ContextCompat.getColorStateList(context, R.color.facebook_recommended));
                }
                questionsRG.addView(rb);
            }
            Log.e("getChildView", checkedState.values().toString());

            setListener(groupPosition);
        }

        private void setListener(final int groupPosition) {
            questionsRG.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {

                    AppCompatRadioButton radioButton = (AppCompatRadioButton) questionsRG.findViewById(checkedId);
                    int index = questionsRG.indexOfChild(radioButton);

                    if (index != -1) {
                        checkedState.put(groupPosition, index);
                        Log.e("checked state", checkedState.values().toString());
                        notifyDataSetChanged();
                    }
                }
            });
        }
    }
}