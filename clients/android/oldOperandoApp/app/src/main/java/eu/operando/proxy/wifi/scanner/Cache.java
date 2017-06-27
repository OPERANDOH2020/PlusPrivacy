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

import android.net.wifi.ScanResult;

import org.apache.commons.lang3.builder.CompareToBuilder;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Deque;
import java.util.List;

class Cache {
    protected static final int MAX_CACHE_SIZE = 3;

    private final Deque<List<ScanResult>> cache = new ArrayDeque<>(MAX_CACHE_SIZE);

    protected List<ScanResult> getScanResults() {
        ScanResult current = null;
        List<ScanResult> results = new ArrayList<>();
        for (ScanResult scanResult : combineCache()) {
            if (current != null && scanResult.BSSID.equals(current.BSSID)) {
                continue;
            }
            current = scanResult;
            results.add(scanResult);
        }
        return results;
    }

    private List<ScanResult> combineCache() {
        List<ScanResult> scanResults = new ArrayList<>();
        for (List<ScanResult> cachedScanResults : cache) {
            scanResults.addAll(cachedScanResults);
        }
        Collections.sort(scanResults, new ScanResultComparator());
        return scanResults;
    }

    protected void add(List<ScanResult> scanResults) {
        if (!cache.isEmpty() && cache.size() == MAX_CACHE_SIZE) {
            cache.removeLast();
        }
        if (scanResults != null) {
            cache.addFirst(scanResults);
        }
    }

    protected Deque<List<ScanResult>> getCache() {
        return cache;
    }

    private static class ScanResultComparator implements Comparator<ScanResult> {
        @Override
        public int compare(ScanResult lhs, ScanResult rhs) {
            return new CompareToBuilder()
                    .append(lhs.BSSID, rhs.BSSID)
                    .append(rhs.level, lhs.level)
                    .toComparison();
        }
    }
}
