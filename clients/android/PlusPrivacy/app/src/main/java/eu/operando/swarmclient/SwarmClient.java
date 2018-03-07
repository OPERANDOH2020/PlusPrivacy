package eu.operando.swarmclient;

import android.content.Context;
import android.content.IntentFilter;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.support.design.widget.Snackbar;
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

import eu.operando.PlusPrivacyApp;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import eu.operando.utils.ConnectivityReceiver;
import eu.operando.utils.NetworkUtil;
import io.socket.client.Ack;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import okhttp3.OkHttpClient;

/**
 * Created by Edy on 11/2/2016.
 */

public class SwarmClient {
    private static SwarmClient instance;
    private String connectionURL;
    private Context context;
    private Socket ioSocket;
    private Gson gson;
    private HashMap<String, SwarmCallback> listeners;
    private ConnectionListener connectionListener;

    public SwarmClient(final String connectionURL) {

        this.connectionURL = connectionURL;
        listeners = new HashMap<>();

        setSocket();

        gson = new Gson();
    }

    private void setSocket() {
        final IO.Options options = new IO.Options();
        SSLContext sslContext;
        try {
            if (connectionURL.startsWith("https://")) {
                HostnameVerifier verifier = new HostnameVerifier() {
                    @Override
                    public boolean verify(String hostname, SSLSession session) {
                        return true;
                    }
                };
                sslContext = SSLContext.getInstance("TLS");
                sslContext.init(null, new TrustManager[]{new X509TrustManager() {
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

                OkHttpClient okHttpClient = new OkHttpClient.Builder()
                        .hostnameVerifier(verifier)
                        .sslSocketFactory(sslContext.getSocketFactory())
                        .build();

// default settings for all sockets
                IO.setDefaultOkHttpWebSocketFactory(okHttpClient);
                IO.setDefaultOkHttpCallFactory(okHttpClient);
//                IO.setDefaultSSLContext(sslContext);
//                IO.setDefaultHostnameVerifier(verifier);
//                options.sslContext = sslContext;
//                options.hostnameVerifier = verifier;
                options.secure = true;
                options.callFactory = okHttpClient;
                options.webSocketFactory = okHttpClient;
            }

            options.forceNew = true;
            options.reconnection = true;
            options.reconnectionDelay = 1000;
            options.timeout = 1000;

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
            this.ioSocket.on("data", onNewMessage);
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
                    Log.e("Connect", "call() called with: args = [" + Arrays.toString(args) + "]" + ioSocket.id());

                    if (connectionListener != null) {
                        connectionListener.onConnect();
                    }
                }
            });

            this.ioSocket.on("error", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("error", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });

            this.ioSocket.on("reconnect", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("reconnect", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("connect_error", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("connect_error", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("retry", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("retry", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("reconnect_failed", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("reconnect_failed", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("reconnect_error", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("reconnect_error", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("reconnecting", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("reconnecting", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("reconnect_attempt", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("reconnect_attempt", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });
            this.ioSocket.on("connect_timeout", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    Log.e("connect_timeout", "call() called with: args = [" + Arrays.toString(args) + "]");
                }
            });

        } catch (URISyntaxException | NoSuchAlgorithmException | KeyManagementException exception) {
            exception.printStackTrace();
        }
    }

    public void startSwarm(Swarm swarm, SwarmCallback callback) {
        if (callback != null) {
            callback.setResultEvent(swarm.getMeta().getCtor());
            listeners.put(callback.getResultEvent(), callback);
        }
        try {
            Log.e("startSwarm", new JSONObject(gson.toJson(swarm)).toString());
            ioSocket.emit("message", new JSONObject(gson.toJson(swarm)), new Ack(){
                @Override
                public void call(Object... args) {
                    Ack ack = (Ack) args[args.length - 1];
                    ack.call();
                    Log.e("ack", "call");
                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.d("swclient EMIT", "startSwarm() called with: swarm = [" + swarm + "], callback = [" + callback + "]");
    }

    public void startSwarm(SwarmCallback callback, String swarmingName, String ctor, Object... args) {
        Swarm swarm = new Swarm(swarmingName, ctor, args);
        startSwarm(swarm, callback);
    }

    public void setConnectionListener(ConnectionListener connectionListener) {
        this.connectionListener = connectionListener;
    }

    public interface ConnectionListener {
        void onConnect();

        void onDisconnect();
    }

}