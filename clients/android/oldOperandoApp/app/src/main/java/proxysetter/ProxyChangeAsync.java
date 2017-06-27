/*
 * Copyright (c) 2016 John Paul Krause.
 * ProxyChangeAsync.java is part of AndroidProxySetter.
 *
 * AndroidProxySetter is free software: you can redistribute it and/or modify
 * iit under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * AndroidProxySetter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with AndroidProxySetter.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

package proxysetter;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;


/**
 * Async task that handles executing the proxy change request
 */
public class ProxyChangeAsync extends AsyncTask<Object, String, Void> {

	private Context context;
	private ProxyChangeExecutor executor;

	private static final String TAG = "ProxySetterApp";

	public ProxyChangeAsync(Context context) {
		this.context = context;
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		// init executor and register it to receive wifi state change broadcasts
		executor = new ProxyChangeExecutor(this);
		context.registerReceiver(executor, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
	}

	@Override
	protected Void doInBackground(Object... params) {

		// Looper is needed to handle broadcast messages
		try {
			Looper.prepare();
		} catch (Exception e) {
			Log.e(TAG, "Error starting looper on thread", e);
		}

		executor.executeChange((Intent) params[0]);
		return null;
	}


	@Override
	public void onProgressUpdate(String... values) {
		super.onProgressUpdate(values);
		final String msg = values[0];
        Handler handler =  new Handler(context.getMainLooper());
        handler.post(new Runnable() {
            public void run() {
                Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
            }
        });

        Log.e(TAG, msg);
	}

    @Override
    protected void onCancelled(Void aVoid) {
        context.unregisterReceiver(executor);
    }

	@Override
	protected void onPostExecute(Void aVoid) {
		context.unregisterReceiver(executor);
	}
}