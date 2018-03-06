package eu.operando.feedback.view;

import android.content.Context;
import android.support.annotation.IdRes;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;

import static eu.operando.feedback.entity.FeedbackSubmitEntitty.MULTIPLE_RATING;
import static eu.operando.feedback.entity.FeedbackSubmitEntitty.MULTIPLE_SELECTION;
import static eu.operando.feedback.entity.FeedbackSubmitEntitty.RADIO;
import static eu.operando.feedback.entity.FeedbackSubmitEntitty.TEXT_INPUT;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackQuestionsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private static final int MULTIPLE_RATING_NO = 1;
    private static final int MULTIPLE_SELECTION_NO = 2;
    private static final int TEXT_INPUT_NO = 3;
    private static final int RADIO_NO = 4;

    private List<FeedbackQuestionEntity> list;
    private Context context;
    private FeedbackSubmitEntitty feedbackSubmitEntitty;

    public FeedbackQuestionsAdapter(List<FeedbackQuestionEntity> items, Context context, FeedbackSubmitEntitty feedbackSubmitEntitty) {
        this.list = items;
        this.context = context;
        this.feedbackSubmitEntitty = feedbackSubmitEntitty;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View itemView;
        Log.e("viewtype", String.valueOf(viewType));
        switch (viewType) {
            case MULTIPLE_RATING_NO:
                itemView = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.feedback_question_item_multiple_rating, parent, false);
                return new MultipleRatingViewHolder(itemView);
            case MULTIPLE_SELECTION_NO:
                itemView = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.feedback_question_item_multiple_selection, parent, false);
                return new MultipleSelectionViewHolder(itemView);
            case TEXT_INPUT_NO:
                itemView = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.feedback_question_item_text_input, parent, false);
                return new TextInputViewHolder(itemView);
            case RADIO_NO:
                itemView = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.feedback_question_item_radio, parent, false);
                return new RadioGroupViewHolder(itemView);
            default:
                itemView = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.feedback_question_item_multiple_rating, parent, false);
                return new MultipleRatingViewHolder(itemView);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {

        final FeedbackQuestionEntity question = list.get(position);

        switch (getItemViewType(position)) {
            case MULTIPLE_RATING_NO:
                setDataMultipleRatingViewHolder((MultipleRatingViewHolder) holder, question);
                break;
            case MULTIPLE_SELECTION_NO:
                setDataMultipleSelectionViewHolder((MultipleSelectionViewHolder) holder, question);
                break;
            case TEXT_INPUT_NO:
                setDataTextInputViewHolder((TextInputViewHolder) holder, question);
                break;
            case RADIO_NO:
                setDataRadioGroupViewHolder((RadioGroupViewHolder) holder, question);
                break;
            default:
                ((MultipleRatingViewHolder) holder).title.setText(question.getTitle());
                break;
        }
    }

    private void setDataTextInputViewHolder(final TextInputViewHolder holder, final FeedbackQuestionEntity question) {
        if (question.isRequired()) {
            holder.title.setText(Html.fromHtml(
                    question.getTitle() + " " + context.getString(R.string.required_field)));
        } else {
            holder.title.setText(question.getTitle());
        }

        holder.editText.setText(
                feedbackSubmitEntitty.getStringValue(question.getTitle())
        );

        holder.editText.addTextChangedListener(new TextWatcher() {

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                Log.e("editText", s.toString());
                feedbackSubmitEntitty.putStringAnswer(
                        question.getTitle(),
                        s.toString()
                );
            }
        });
    }

    public String getSubmitTitleForItems(FeedbackQuestionEntity question, String item) {
        StringBuilder sb = new StringBuilder();
        sb.append(question.getTitle())
                .append("[")
                .append(item)
                .append("]");
        return sb.toString();
    }

    private void setDataMultipleSelectionViewHolder(MultipleSelectionViewHolder holder, final FeedbackQuestionEntity question) {
        if (holder.title.getText().equals("")) {
            if (question.isRequired()) {
                holder.title.setText(Html.fromHtml(
                        question.getTitle() + " " + context.getString(R.string.required_field)));
            } else {
                holder.title.setText(question.getTitle());
            }

            LinearLayout ll = (LinearLayout) ((View) holder.title.getParent()).findViewById(R.id.feedback_question_item_multiple_checkbox_ll);
            for (String item : question.getItems()) {
                final CheckBox checkbox = new CheckBox(context);
                checkbox.setText(item);
                checkbox.setPadding(context.getResources().getDimensionPixelSize(R.dimen.feedback_padding), 0, 0, 0);
                checkbox.setTextColor(ContextCompat.getColor(context, R.color.primary_text));

                String submitTitle = getSubmitTitleForItems(question, item);
                if (feedbackSubmitEntitty.getBooleanValue(submitTitle)){
                    checkbox.setChecked(true);
                }

                checkbox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if (buttonView == checkbox) {
                            String submitTitle = getSubmitTitleForItems(question, buttonView.getText().toString());
                            feedbackSubmitEntitty.putBooleanAnswer(submitTitle, isChecked);
                        }
                    }
                });
                ll.addView(checkbox);
            }
        }
    }

    private void setDataRadioGroupViewHolder(RadioGroupViewHolder holder, final FeedbackQuestionEntity question) {
        if (holder.title.getText().equals("")) {
            if (question.isRequired()) {
                holder.title.setText(Html.fromHtml(
                        question.getTitle() + " " + context.getString(R.string.required_field)));
            } else {
                holder.title.setText(question.getTitle());
            }

            List<String> items = question.getItems();
            for (int i = 0; i < items.size(); ++i) {
                RadioButton rb = new RadioButton(context);
                rb.setTextColor(ContextCompat.getColor(context, R.color.primary_text));
                rb.setText(items.get(i));
                rb.setId(View.generateViewId());
                holder.radioGroup.addView(rb);
                if (feedbackSubmitEntitty.getStringValue(question.getTitle()).equals(items.get(i))) {
                    rb.setChecked(true);
                }
            }
            holder.radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                    int id = group.getCheckedRadioButtonId();
                    RadioButton rb = (RadioButton) group.findViewById(id);
                    feedbackSubmitEntitty.putStringAnswer(question.getTitle(), (String) rb.getText());
                }
            });
        }
    }

    private void setDataMultipleRatingViewHolder(MultipleRatingViewHolder holder, FeedbackQuestionEntity question) {

        if (holder.title.getText().equals("")) {
            if (question.isRequired()) {
                holder.title.setText(Html.fromHtml(
                        question.getTitle() + " " + context.getString(R.string.required_field)));
            } else {
                holder.title.setText(question.getTitle());
            }
            holder.description.setText(question.getDescription());

            setTvRatings(holder, question);
            setOptionsForMultipleRating(holder, question);
        }
    }

    private void setOptionsForMultipleRating(MultipleRatingViewHolder holder, final FeedbackQuestionEntity question) {

        for (String item : question.getItems()) {
            View itemView = LayoutInflater.from(context)
                    .inflate(R.layout.feedback_question_item_multiple_rating_rg_layout, (ViewGroup) holder.title.getParent(), false);
            final TextView tv = (TextView) itemView.findViewById(R.id.multiple_rating_layout_tv);
            final RadioGroup rg = (RadioGroup) itemView.findViewById(R.id.multiple_rating_layout_rg);
            for (String rating : question.getRange()) {
                RadioButton rb = new RadioButton(context);
                rb.setPadding(0, 0, 0, 0);
                rb.setId(rg.getId() + Integer.parseInt(rating));
                rg.addView(rb);

                String submitTitle = getSubmitTitleForItems(question, item);
                if (feedbackSubmitEntitty.getStringValue(submitTitle).equals(rating)){
                    rb.setChecked(true);
                }
            }
            tv.setText(item);
            tv.setTextColor(ContextCompat.getColor(context, R.color.primary_text));
            holder.optionsLayout.addView(itemView);
            rg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                    int id = group.getCheckedRadioButtonId();
                    RadioButton rb = (RadioButton) group.findViewById(id);
                    String submitTitle = getSubmitTitleForItems(question, tv.getText().toString());
                    feedbackSubmitEntitty.putStringAnswer(submitTitle, String.valueOf(rb.getId() - rg.getId()));
                }
            });
        }
    }

    private void setTvRatings(MultipleRatingViewHolder holder, FeedbackQuestionEntity question) {
        for (int i = 0; i < question.getRange().size(); ++i) {

            TextView tv = new TextView(context);
            tv.setText(question.getRange().get(i));
            tv.setTextColor(ContextCompat.getColor(context, R.color.primary_text));
            tv.setGravity(Gravity.RIGHT);
            tv.setPadding(0, 0, convertDpToPx(24), 0);

            holder.ratingsLayout.addView(tv);
        }
    }

    private int convertDpToPx(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.getResources().getDisplayMetrics());
    }

    @Override
    public int getItemViewType(int position) {
        switch (list.get(position).getType()) {
            case MULTIPLE_RATING:
                return 1;
            case MULTIPLE_SELECTION:
                return 2;
            case TEXT_INPUT:
                return 3;
            case RADIO:
                return 4;
            default:
                return 0;
        }
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    private class MultipleRatingViewHolder extends RecyclerView.ViewHolder {

        TextView title;
        TextView description;
        LinearLayout optionsLayout;
        LinearLayout ratingsLayout;

        MultipleRatingViewHolder(View itemView) {
            super(itemView);

            title = (TextView) itemView.findViewById(R.id.feedback_question_item_title);
            description = (TextView) itemView.findViewById(R.id.feedback_question_item_description);
            ratingsLayout = (LinearLayout) itemView.findViewById(R.id.feedback_question_item_multiple_rating_layout_ratings);
            optionsLayout = (LinearLayout) itemView.findViewById(R.id.feedback_question_item_multiple_rating_layout_options);
        }
    }

    private class TextInputViewHolder extends RecyclerView.ViewHolder {

        EditText editText;
        TextView title;

        TextInputViewHolder(View itemView) {
            super(itemView);

            title = (TextView) itemView.findViewById(R.id.feedback_question_item_et_title);
            editText = (EditText) itemView.findViewById(R.id.feedback_question_item_et_edit_text);
        }
    }

    private static class RadioGroupViewHolder extends RecyclerView.ViewHolder {
        RadioGroup radioGroup;
        TextView title;

        RadioGroupViewHolder(View itemView) {
            super(itemView);

            title = (TextView) itemView.findViewById(R.id.feedback_question_item_radio_title);
            radioGroup = (RadioGroup) itemView.findViewById(R.id.feedback_question_item_radio_rg);
        }
    }

    private static class MultipleSelectionViewHolder extends RecyclerView.ViewHolder {

        TextView title;

        public MultipleSelectionViewHolder(View itemView) {
            super(itemView);

            title = (TextView) itemView.findViewById(R.id.feedback_question_item_multiple_selection_title);
        }
    }
}
