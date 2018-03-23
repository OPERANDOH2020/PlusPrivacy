package aspectj.archinamon.alex.hookframework.xpoint.android.hooks.javaApi;

public abstract class HookEvent {

    public boolean shouldCall = true;
    public String methodName;
    public HookEvent nextInChain;

    public HookEvent(String methodName) {
        this.methodName = methodName;
    }

    public abstract void beforeCall(Object[] args);

    public abstract Object afterCall(Object obj);

    public void add(HookEvent next) {
        if (nextInChain == null) {
            nextInChain = next;
        } else {
            nextInChain.add(next);
        }
    }

    public void stopPropagation() {
        shouldCall = false;
        nextInChain = null;
    }
}
