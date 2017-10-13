package eu.operando.swarmclient;

import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.HashMap;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

/**
 * Created by Edy on 11/2/2016.
 */

public class SwarmClient {
    private static SwarmClient instance;
    private String connectionURL;

    private Socket ioSocket;
    private Gson gson;
    private HashMap<String, SwarmCallback> listeners;
    private ConnectionListener connectionListener;

    private SwarmClient(final String connectionURL) {
        this.connectionURL = connectionURL;
        listeners = new HashMap<>();
        IO.Options options = new IO.Options();
        SSLContext context;
        try {
            if (connectionURL.startsWith("https://")) {
                HostnameVerifier verifier = new HostnameVerifier() {
                    @Override
                    public boolean verify(String hostname, SSLSession session) {
                        return true;
                    }
                };
                context = SSLContext.getInstance("TLS");
                context.init(null, new TrustManager[]{new X509TrustManager() {
                    public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                        return new java.security.cert.X509Certificate[]{};
                    }

                    public void checkClientTrusted(X509Certificate[] chain,
                                                   String authType) throws CertificateException {
                    }

                    public void checkServerTrusted(X509Certificate[] chain,
                                                   String authType) throws CertificateException {
                    }
                }}, null);
                IO.setDefaultSSLContext(context);
                IO.setDefaultHostnameVerifier(verifier);
                options.sslContext = context;
                options.hostnameVerifier = verifier;
                options.secure = true;
            }

            ioSocket = IO.socket(connectionURL, options);
            ioSocket.connect();
            Emitter.Listener onNewMessage = new Emitter.Listener() {
                @Override
                public void call(final Object... args) {
                    JSONObject data = (JSONObject) args[0];
                    Log.w("Swarms: ", "received: " + data);
                    Swarm swarm = gson.fromJson(data.toString(), Swarm.class);
                    if (listeners.containsKey(swarm.getMeta().getCtor())) {
                        listeners.get(swarm.getMeta().getCtor()).result(data);
                    }
                }
            };

            this.ioSocket.on("message", onNewMessage);
            this.ioSocket.on("disconnect", new Emitter.Listener() {
                @Override
                public void call(Object... args) {

                    Log.e("Disconnect", "call() called with: args = [" + Arrays.toString(args) + "]");
                    if (connectionListener != null) {
                        connectionListener.onDisconnect();
                    }
                }
            });
            this.ioSocket.on("connect", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("Connect", "call() called with: args = [" + Arrays.toString(args) + "]");


//                    SwarmService.getInstance().autoLogin();
                    if (connectionListener != null) {
                        connectionListener.onConnect();
                    }
                }
            });

        } catch (URISyntaxException | NoSuchAlgorithmException | KeyManagementException exception) {
            exception.printStackTrace();
        }
        gson = new Gson();
    }

    public static void init(String connectionURL) {
        instance = new SwarmClient(connectionURL);
    }

    public static SwarmClient getInstance() {
        if (instance == null) throw new IllegalStateException("init() was not called.");

        return instance;
    }

    public void startSwarm(Swarm swarm, SwarmCallback callback) {
        if (callback != null) {
            callback.setResultEvent(swarm.getMeta().getCtor());
            listeners.put(callback.getResultEvent(), callback);
        }
        try {
            Log.e("startSwarm", new JSONObject(gson.toJson(swarm)).toString());
            ioSocket.emit("message", new JSONObject(gson.toJson(swarm)));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.d("swclient EMIT", "startSwarm() called with: swarm = [" + swarm + "], callback = [" + callback + "]");
    }

    public void startSwarm(String swarmingName, String ctor, SwarmCallback callback) {
        Swarm swarm = new Swarm(swarmingName, ctor);
        if (callback != null) {
            callback.setResultEvent(swarm.getMeta().getCtor());
            listeners.put(callback.getResultEvent(), callback);
        }
        try {
            Log.e("startSwarm", new JSONObject(gson.toJson(swarm)).toString());
            ioSocket.emit("message", new JSONObject(gson.toJson(swarm)));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.d("swclient EMIT", "startSwarm() called with: swarm = [" + swarm + "], callback = [" + callback + "]");
    }

    public void startSwarm(SwarmCallback callback, String swarmingName, String ctor, Object... args) {
        Swarm swarm = new Swarm(swarmingName, ctor, args);
        if (callback != null) {
            callback.setResultEvent(swarm.getMeta().getCtor());
            listeners.put(callback.getResultEvent(), callback);
        }
        try {
            Log.e("startSwarm", new JSONObject(gson.toJson(swarm)).toString());
            ioSocket.emit("message", new JSONObject(gson.toJson(swarm)));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.d("swclient EMIT", "startSwarm() called with: swarm = [" + swarm + "], callback = [" + callback + "]");
    }

    public void setConnectionListener(ConnectionListener connectionListener) {
        this.connectionListener = connectionListener;
    }

    public void restartSocket() {
        instance.ioSocket.disconnect();
        instance = new SwarmClient(connectionURL);
    }

    public interface ConnectionListener {
        void onConnect();

        void onDisconnect();
    }
}
