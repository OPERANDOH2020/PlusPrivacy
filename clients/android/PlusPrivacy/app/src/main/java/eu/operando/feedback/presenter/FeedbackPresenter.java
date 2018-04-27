package eu.operando.feedback.presenter;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface FeedbackPresenter {
    void onLoading();

    void onDestroy();

    void saveState();

    void submitFeedback();

    void onClickChangeFeedbackResponse();

    void restoreState();
}
