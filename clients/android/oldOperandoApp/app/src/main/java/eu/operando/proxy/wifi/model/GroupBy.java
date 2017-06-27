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

import android.support.annotation.NonNull;

import org.apache.commons.lang3.builder.CompareToBuilder;

import java.util.Comparator;

public enum GroupBy {
    NONE(new None(), new None()),
    SSID(new SSIDSortOrder(), new SSIDGroupBy()),
    CHANNEL(new ChannelSortOrder(), new ChannelGroupBy());

    private final Comparator<WiFiDetail> sortOrder;
    private final Comparator<WiFiDetail> groupBy;

    GroupBy(@NonNull Comparator<WiFiDetail> sortOrder, @NonNull Comparator<WiFiDetail> groupBy) {
        this.sortOrder = sortOrder;
        this.groupBy = groupBy;
    }

    public static GroupBy find(int index) {
        try {
            return values()[index];
        } catch (Exception e) {
            return GroupBy.NONE;
        }
    }

    Comparator<WiFiDetail> sortOrder() {
        return sortOrder;
    }

    Comparator<WiFiDetail> groupBy() {
        return groupBy;
    }

    static class None implements Comparator<WiFiDetail> {
        @Override
        public int compare(WiFiDetail lhs, WiFiDetail rhs) {
            return lhs.equals(rhs) ? 0 : 1;
        }
    }

    static class SSIDSortOrder implements Comparator<WiFiDetail> {
        @Override
        public int compare(WiFiDetail lhs, WiFiDetail rhs) {
            return new CompareToBuilder()
                    .append(lhs.getSSID().toUpperCase(), rhs.getSSID().toUpperCase())
                    .append(rhs.getWiFiSignal().getLevel(), lhs.getWiFiSignal().getLevel())
                    .append(lhs.getBSSID().toUpperCase(), rhs.getBSSID().toUpperCase())
                    .toComparison();
        }
    }

    static class SSIDGroupBy implements Comparator<WiFiDetail> {
        @Override
        public int compare(WiFiDetail lhs, WiFiDetail rhs) {
            return new CompareToBuilder()
                    .append(lhs.getSSID().toUpperCase(), rhs.getSSID().toUpperCase())
                    .toComparison();
        }
    }

    static class ChannelSortOrder implements Comparator<WiFiDetail> {
        @Override
        public int compare(WiFiDetail lhs, WiFiDetail rhs) {
            return new CompareToBuilder()
                    .append(lhs.getWiFiSignal().getWiFiChannel().getChannel(), rhs.getWiFiSignal().getWiFiChannel().getChannel())
                    .append(rhs.getWiFiSignal().getLevel(), lhs.getWiFiSignal().getLevel())
                    .append(lhs.getSSID().toUpperCase(), rhs.getSSID().toUpperCase())
                    .append(lhs.getBSSID().toUpperCase(), rhs.getBSSID().toUpperCase())
                    .toComparison();
        }
    }

    static class ChannelGroupBy implements Comparator<WiFiDetail> {
        @Override
        public int compare(WiFiDetail lhs, WiFiDetail rhs) {
            return new CompareToBuilder()
                    .append(lhs.getWiFiSignal().getWiFiChannel().getChannel(), rhs.getWiFiSignal().getWiFiChannel().getChannel())
                    .toComparison();
        }
    }

}
