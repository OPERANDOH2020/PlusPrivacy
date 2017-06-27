package eu.operando.events;

/**
 * Created by raluca on 06.04.2016.
 */
public class EventLoginPage implements IEvent {

    public int action ;

    public EventLoginPage (int action){
        this.action = action;
    }
}
