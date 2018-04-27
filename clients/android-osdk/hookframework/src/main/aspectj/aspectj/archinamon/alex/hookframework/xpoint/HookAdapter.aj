package xpoint;

import android.hardware.SensorEvent;
import android.location.Location;
import android.util.Log;


import com.squareup.okhttp.FormEncodingBuilder;



import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.HookFramework;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.Behavior;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin.AbstractPlugin;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.event.AbstractEvent;


import org.aspectj.lang.JoinPoint;

import java.io.InputStream;
import java.lang.reflect.Field;

import okio.Buffer;


privileged aspect HookAdapter {

    private HookFramework hookFramework = HookFramework.getInstance();

    pointcut callOnSensorChanged(SensorEvent event):execution( public void android.hardware.SensorEventListener +.onSensorChanged(SensorEvent)) && args(event);
    pointcut callStartMediaRecorder():call( public void android.media.MediaRecorder.start());
    pointcut callOnLocationChanged(Location location):execution( public void android.location.LocationListener+.onLocationChanged(Location)) && args(location);
    void around ():callOnLocationChanged(Location) || callOnSensorChanged(SensorEvent)
            || callStartMediaRecorder(){

        new Behavior<Void>(hookFramework, thisJoinPoint) {

            @Override
            public Void pluginNotRegistered() {
                proceed();
                return null;
            }

            @Override
            public Void interceptorNotRegistered() {
                proceed();
                return null;
            }

            @Override
            public Void afterCallReturn(AbstractEvent event, AbstractInterceptor interceptor) {
                proceed();
                if (thisJoinPoint.getArgs().length != 0) {

                    event.modifyValue(thisJoinPoint.getArgs()[0]);
                }
                interceptor.afterCall(event.getValue());
                return null;
            }
        }.run();
    }


    public pointcut callNewIntent(String action): call(public android.content.Intent.new(String)) && args(action);
    public pointcut callGetLastKnownLocation(String provider): call(public Location android.location.LocationManager.getLastKnownLocation(String)) && args(provider);
    public pointcut callOnBatteryChanged(String name, int defaultValue):call( public int android.content.Intent+.getIntExtra(String, int)) && args(name, defaultValue);
    Object around(): callOnBatteryChanged(String, int) || callGetLastKnownLocation(String)
        || callNewIntent(String){

        return new Behavior<Object>(hookFramework, thisJoinPoint) {

            @Override
            public Object pluginNotRegistered() {
                return proceed();
            }

            @Override
            public Object interceptorNotRegistered() {
                return proceed();
            }

            @Override
            public Object afterCallReturn(AbstractEvent event, AbstractInterceptor interceptor) {
                event.modifyValue(proceed());
                return interceptor.afterCall(proceed());
            }

        }.run();
    }

    public pointcut callSocketOutputStream(): call(public * java.net.Socket.getOutputStream());
    public pointcut callNewSocket(): call(public java.net.Socket.new(..));
    public pointcut callSocket(): call(* java.net.Socket.*(..));
    public pointcut callURL(): call(* java.net.URL.*(..));
    public pointcut callHttpURLConnection(): call( * java.net.HttpURLConnection.*(..));
    public pointcut callOkHttpClient(): call(* com.squareup.okhttp.OkHttpClient.*(..));
    public pointcut callApacheHttpClient(): call(* org.apache.http.client.HttpClient.*(..));
    public pointcut callSocketChannel(): call(* java.nio.channels.SocketChannel.*(..));
    public pointcut callSocketImpl(): call(* java.net.SocketImpl.*(..));
    public pointcut callInetAddress(): call(* java.net.InetAddress.*(..));
    public pointcut callInetSocketAddress(): call(* java.net.InetSocketAddress.*(..));
    public pointcut callURLConnection(): call(* java.net.URLConnection.*(..));
    public pointcut callUri(): call(* java.net.Uri.*(..));
    public pointcut callSocketFactory(): call(* javax.net.SocketFactory.*(..));
    public pointcut callJavaNetPacket(): call(* java.net.*.*(..));
    public pointcut callOkHttp(): call(* com.squareup.okhttp.*.*(..));

    Object around():
            callSocket() || callURL() || callHttpURLConnection()
                    || callSocketChannel() || callSocketImpl() || callInetAddress() || callURLConnection() ||
                    callUri() || callApacheHttpClient() || callSocketFactory() || callInetSocketAddress() {
//        Log.e("callNewSocket", thisJoinPoint.getArgs()[0].toString());
        Log.e("callNetwork", thisJoinPoint.getSignature().getDeclaringType().toString() + " " +
                thisJoinPoint.getSignature().getName());
        return proceed();
    }

    public pointcut callRequestBodyOkHttp(): call(* com.squareup.okhttp.OkHttpClient.newCall(..));
    Object around(): callRequestBodyOkHttp() {

        Log.e("callRequestBody", "callRequestBody");
        return new Behavior<Object>(hookFramework, thisJoinPoint) {

            /*public boolean check(JoinPoint thisJoinPoint) {

                Field field = null;
                try {
                    field = FormEncodingBuilder.class.getDeclaredField("content");
                    field.setAccessible(true);
                    Buffer iWantThis = (Buffer) field.get(thisJoinPoint.getTarget()); //IllegalAccessException
                    String body = iWantThis.readUtf8();
                    Log.e("callRequestBody", body);
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                return true;
            }*/

            @Override
            public Object pluginNotRegistered() {
                return proceed();
            }

            @Override
            public Object interceptorNotRegistered() {
                return proceed();
            }

            @Override
            public Object afterCallReturn(AbstractEvent event, AbstractInterceptor interceptor) {
                event.modifyValue(proceed());
                return interceptor.afterCall(event.getValue(), thisJoinPoint.getArgs());
            }
        }.run();
    }

    public pointcut callSocketGetInputStream(): call(public InputStream java.net.Socket.getInputStream());
    Object around(): callSocketGetInputStream() {

        return new Behavior<Object>(hookFramework, thisJoinPoint) {

            public boolean check(JoinPoint thisJoinPoint) {
                return true;
            }

            @Override
            public Object pluginNotRegistered() {
                return proceed();
            }

            @Override
            public Object interceptorNotRegistered() {
                return proceed();
            }

            @Override
            public Object afterCallReturn(AbstractEvent event, AbstractInterceptor interceptor) {
                InputStream inputStream = (InputStream) proceed();
                Log.e("callSocketGetInputStream", inputStream.toString());
                event.modifyValue(inputStream);
                return interceptor.afterCall(event.getValue());
            }
        }.run();
    }
}