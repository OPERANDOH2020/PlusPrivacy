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

package eu.operando.proxy.util;

/**
 * Created by nikos on 5/15/16.
 */

import java.io.Closeable;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.net.Socket;

/**
 * Utility methods for working with {@link Closeable} objects.
 */
public final class Closeables {

    private Closeables() {
    }

    /**
     * Closes the provided {@link Socket} and consumes the {@link IOException} that this operation
     * may throw. Does nothing if the {@code Socket} is {@code null}.
     * <p/>
     * <p>This method is specially designed for {@code Socket} instances because on older Android
     * platforms {@code Socket} does not implement {@link Closeable}.
     */
    public static void closeQuietly(Socket socket) {
        if (socket == null) {
            return;
        }
        try {
            socket.close();
        } catch (IOException ignored) {
        }
    }

    /**
     * Closes the provided {@link Reader} and consumes the {@link IOException} that this
     * operation may throw. Does nothing if the {@code Socket} is {@code null}.
     * <p/>
     * <p>This method is specially designed for {@code Reader} instances because on older Android
     * platforms {@code Socket} does not implement {@link Closeable}.
     */
    public static void closeQuietly(Reader in) {
        if (in == null) {
            return;
        }
        try {
            in.close();
        } catch (IOException ignored) {
        }
    }

    /**
     * Closes the provided {@link InputStream} and consumes the {@link IOException} that this
     * operation may throw. Does nothing if the {@code Socket} is {@code null}.
     * <p/>
     * <p>This method is specially designed for {@code InputStream} instances because on older Android
     * platforms {@code Socket} does not implement {@link Closeable}.
     */
    public static void closeQuietly(InputStream in) {
        if (in == null) {
            return;
        }
        try {
            in.close();
        } catch (IOException ignored) {
        }
    }
}