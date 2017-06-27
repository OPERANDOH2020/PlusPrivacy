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

package eu.operando.proxy.settings;


import eu.operando.R;

public enum ThemeStyle {
    DARK(R.style.ThemeAppCompatDark, R.style.ThemeDeviceDefaultDark),
    LIGHT(R.style.ThemeAppCompatLight, R.style.ThemeDeviceDefaultLight);

    private final int themeAppCompatStyle;
    private final int themeDeviceDefaultStyle;

    ThemeStyle(int themeAppCompatStyle, int themeDeviceDefaultStyle) {
        this.themeAppCompatStyle = themeAppCompatStyle;
        this.themeDeviceDefaultStyle = themeDeviceDefaultStyle;
    }

    public static ThemeStyle find(int index) {
        try {
            return values()[index];
        } catch (Exception e) {
            return DARK;
        }
    }

    public int themeAppCompatStyle() {
        return themeAppCompatStyle;
    }

    public int themeDeviceDefaultStyle() {
        return themeDeviceDefaultStyle;
    }
}
