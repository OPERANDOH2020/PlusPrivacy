package eu.operando.feedback.view;

import java.util.List;

import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface FeedbackView {

    void showProgress();

    void hideProgress();

    void setItems(List<FeedbackQuestionEntity> items, FeedbackSubmitEntitty submitEntitty);

    void showMessageForSubmittedFeedback(String message);

    void showMessageForErrorOnSubmit(String message);

    void installFeedbackFragment();

    void uninstallFeedbackFragment();
}
