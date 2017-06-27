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

/**
 * Hexadecimal encoding where each byte is represented by two hexadecimal digits.
 */
public final class HexEncoding {
    private HexEncoding() {
    }

    private static final char[] HEX_DIGITS = "0123456789abcdef".toCharArray();

    /**
     * Encodes the provided data as a hexadecimal string.
     */
    public static String encode(byte[] data, int offset, int len) {
        StringBuilder result = new StringBuilder(len * 2);
        for (int i = 0; i < len; i++) {
            byte b = data[offset + i];
            result.append(HEX_DIGITS[(b >>> 4) & 0x0f]);
            result.append(HEX_DIGITS[b & 0x0f]);
        }
        return result.toString();
    }

    /**
     * Encodes the provided data as a hexadecimal string.
     */
    public static String encode(byte[] data) {
        return encode(data, 0, data.length);
    }


    /**
     * Decodes the provided hexadecimal string into an array of bytes.
     */
    public static byte[] decode(String encoded) {
        // IMPLEMENTATION NOTE: Special care is taken to permit odd number of hexadecimal digits.
        int resultLengthBytes = (encoded.length() + 1) / 2;
        byte[] result = new byte[resultLengthBytes];
        int resultOffset = 0;
        int encodedCharOffset = 0;
        if ((encoded.length() % 2) != 0) {
            // Odd number of digits -- the first digit is the lower 4 bits of the first result byte.
            result[resultOffset++] = (byte) getHexadecimalDigitValue(encoded.charAt(encodedCharOffset));
            encodedCharOffset++;
        }
        for (int len = encoded.length(); encodedCharOffset < len; encodedCharOffset += 2) {
            result[resultOffset++] = (byte)
                    ((getHexadecimalDigitValue(encoded.charAt(encodedCharOffset)) << 4)
                            | getHexadecimalDigitValue(encoded.charAt(encodedCharOffset + 1)));
        }
        return result;
    }

    private static int getHexadecimalDigitValue(char c) {
        if ((c >= 'a') && (c <= 'f')) {
            return (c - 'a') + 0x0a;
        } else if ((c >= 'A') && (c <= 'F')) {
            return (c - 'A') + 0x0a;
        } else if ((c >= '0') && (c <= '9')) {
            return c - '0';
        } else {
            throw new IllegalArgumentException(
                    "Invalid hexadecimal digit at position : '" + c + "' (0x" + Integer.toHexString(c) + ")");
        }
    }
}