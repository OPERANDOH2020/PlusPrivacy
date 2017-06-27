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

package eu.operando.proxy.wifi.model;


import eu.operando.R;

public enum Strength {
    ZERO(R.drawable.ic_signal_wifi_0_bar_black_48dp, R.color.error_color),
    ONE(R.drawable.ic_signal_wifi_1_bar_black_48dp, R.color.warning_color),
    TWO(R.drawable.ic_signal_wifi_2_bar_black_48dp, R.color.warning_color),
    THREE(R.drawable.ic_signal_wifi_3_bar_black_48dp, R.color.success_color),
    FOUR(R.drawable.ic_signal_wifi_4_bar_black_48dp, R.color.success_color);

    private final int imageResource;
    private final int colorResource;

    Strength(int imageResource, int colorResource) {
        this.imageResource = imageResource;
        this.colorResource = colorResource;
    }

    public static Strength calculate(int level) {
        return Strength.values()[WiFiUtils.calculateSignalLevel(level, values().length)];
    }

    public static Strength reverse(Strength strength) {
        return Strength.values()[Strength.values().length - strength.ordinal() - 1];
    }

    public int colorResource() {
        return colorResource;
    }

    public int imageResource() {
        return imageResource;
    }

    public boolean weak() {
        return ZERO.equals(this);
    }

}
