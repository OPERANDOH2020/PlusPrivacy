package hookframework.xpoint;

import android.util.Log;
import java.util.Arrays;
import org.aspectj.lang.reflect.SourceLocation;

/*
 * @author @zmorris
 */
privileged aspect Tracer {

	private int indentationLevel = 0;

	pointcut traceMethods() : (execution(* *(..)) && !cflow(within(*.example2.*)));

	before(): traceMethods() {
		String indent = indentationLevel > 0 ? new String(new char[indentationLevel]).replace("\0", "\t") : "";
		String method = thisJoinPoint.getSignature().toShortString();
		String params = Arrays.toString(thisJoinPoint.getArgs());
		SourceLocation location = thisJoinPoint.getSourceLocation();
		Thread thread = Thread.currentThread();

        String methodName = method.substring(0, method.indexOf("("));
        String argType = params.substring(0, params.length() - 1).substring(1);
        String fileName = location.getFileName();
        String line = String.valueOf(location.getLine());

        String threadName = thread.getName();
        String threadId = String.valueOf(thread.getId());

		//Log.d("Method ->", indent + methodName + "(" + argType + ") { // " + fileName + ":" + line + " [" + threadName + ":" + threadId + "]");

		indentationLevel++;
	}

	after(): traceMethods() {
		indentationLevel--;

		String indent = indentationLevel > 0 ? new String(new char[indentationLevel]).replace("\0", "\t") : "";
		String method = thisJoinPoint.getSignature().toShortString();
		SourceLocation location = thisJoinPoint.getSourceLocation();
		Thread thread = Thread.currentThread();

        String methodName = method.substring(0, method.indexOf("("));
        String fileName = location.getFileName();
        String line = String.valueOf(location.getLine());

        String threadName = thread.getName();
        String threadId = String.valueOf(thread.getId());

		//Log.d("Method <-", indent + "} // " + methodName + "() " + fileName + ":" + line + " [" + threadName + ":" + threadId + "]");
	}
}