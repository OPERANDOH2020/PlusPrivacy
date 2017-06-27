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

package eu.operando.proxy.database.model;

import org.apache.commons.io.FilenameUtils;

/**
 * Created by nikos on 20/5/2016.
 */
/*
This is a meta-entity. Not saved in the database.
 */
public class FilterFile {
    String source;
    int filterCount;

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public int getFilterCount() {
        return filterCount;
    }

    public void setFilterCount(int filterCount) {
        this.filterCount = filterCount;
    }

    public String getTitle() {
        return FilenameUtils.getBaseName(source) + " (" + filterCount + " entries)";
    }

    @Override
    public String toString() {
        return "FilterFile{" +
                "source='" + source + '\'' +
                ", filterCount=" + filterCount +
                '}';
    }
}
