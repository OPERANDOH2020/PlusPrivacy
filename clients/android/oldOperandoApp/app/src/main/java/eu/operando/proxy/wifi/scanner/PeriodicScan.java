/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy.wifi.scanner;

import android.os.Handler;
import android.support.annotation.NonNull;

import eu.operando.proxy.settings.Settings;


public class PeriodicScan implements Runnable {
    protected static final int DELAY_INITIAL = 1;
    protected static final int DELAY_INTERVAL = 1000;

    private final Scanner scanner;
    private final Handler handler;
    private final Settings settings;
    private boolean running;

    public PeriodicScan(@NonNull Scanner scanner, @NonNull Handler handler, @NonNull Settings settings) {
        this.scanner = scanner;
        this.handler = handler;
        this.settings = settings;
        start();
    }

    public void stop() {
        handler.removeCallbacks(this);
        running = false;
    }

    public void start() {
        nextRun(DELAY_INITIAL);
    }

    private void nextRun(int delayInitial) {
        stop();
        handler.postDelayed(this, delayInitial);
        running = true;
    }

    @Override
    public void run() {
        scanner.update();
        nextRun(settings.getScanInterval() * DELAY_INTERVAL);
    }

    public boolean isRunning() {
        return running;
    }
}
