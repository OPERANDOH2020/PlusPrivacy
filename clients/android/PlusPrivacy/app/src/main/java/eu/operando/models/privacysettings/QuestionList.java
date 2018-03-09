package eu.operando.models.privacysettings;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Alex on 3/9/2018.
 */

public class QuestionList implements Serializable {

    private List<Question> questions;

    public QuestionList(List<Question> questions) {
        this.questions = questions;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }
}
