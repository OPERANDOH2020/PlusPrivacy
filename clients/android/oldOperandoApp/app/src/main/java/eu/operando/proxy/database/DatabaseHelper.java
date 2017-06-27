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

package eu.operando.proxy.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import eu.operando.proxy.database.model.DomainFilter;
import eu.operando.proxy.database.model.FilterFile;
import eu.operando.proxy.database.model.ResponseFilter;


/**
 * Created by nikos on 11/5/2016.
 */
public class DatabaseHelper extends SQLiteOpenHelper {

    // Logcat tag
    private static final String LOG = "DatabaseHelper";

    // Database Version
    private static final int DATABASE_VERSION = 1;

    // Database Name
    private static final String DATABASE_NAME = "openrando.db";

    // Table Names
    private static final String TABLE_RESPONSE_FILTERS = "response_filters";
    private static final String TABLE_DOMAIN_FILTERS = "domain_filters";


    //column names
    private static final String KEY_ID = "id";
    private static final String KEY_MODIFIED = "modified";
    private static final String KEY_CONTENT = "content";
    private static final String KEY_SOURCE = "source";
    private static final String KEY_COUNT = "filtercount";
    private static final String KEY_WILDCARD = "iswildcard";


    private int LIMIT = 500;


    // Table Create Statements
    private static final String CREATE_TABLE_RESPONSE_FILTERS = "CREATE TABLE "
            + TABLE_RESPONSE_FILTERS + "(" + KEY_ID + " INTEGER PRIMARY KEY," + KEY_CONTENT
            + " TEXT," + KEY_SOURCE + " TEXT ," + KEY_MODIFIED
            + " DATETIME" + ")";
    private static final String CREATE_TABLE_DOMAIN_FILTERS = "CREATE TABLE "
            + TABLE_DOMAIN_FILTERS + "(" + KEY_ID + " INTEGER PRIMARY KEY," + KEY_CONTENT
            + " TEXT," + KEY_SOURCE + " TEXT ," + KEY_WILDCARD + " INTEGER ," + KEY_MODIFIED
            + " DATETIME" + ")";


    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        // creating required tables
        db.execSQL(CREATE_TABLE_RESPONSE_FILTERS);
        db.execSQL(CREATE_TABLE_DOMAIN_FILTERS);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // on upgrade drop older tables
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_RESPONSE_FILTERS);
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_DOMAIN_FILTERS);

        // create new tables
        onCreate(db);
    }


    /*
    ------------------------------------------------------------------
    Response Filters
    ------------------------------------------------------------------
     */
    public int createResponseFilter(ResponseFilter responseFilter) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put(KEY_CONTENT, responseFilter.getContent().trim());
        values.put(KEY_SOURCE, responseFilter.getSource());
        values.put(KEY_MODIFIED, getDateTime());

        // insert row
        int id = (int) db.insert(TABLE_RESPONSE_FILTERS, null, values);

        return id;
    }

    public ResponseFilter getResponseFilter(long id) {
        SQLiteDatabase db = this.getReadableDatabase();

        String selectQuery = "SELECT  * FROM " + TABLE_RESPONSE_FILTERS + " WHERE "
                + KEY_ID + " = " + id;


        Cursor c = db.rawQuery(selectQuery, null);

        if (c != null)
            c.moveToFirst();

        ResponseFilter responseFilter = new ResponseFilter();
        responseFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
        responseFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
        responseFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
        responseFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));

        return responseFilter;
    }

    public List<ResponseFilter> getAllResponseFilters() {
        List<ResponseFilter> responseFilters = new ArrayList<ResponseFilter>();
        String selectQuery = "SELECT  * FROM " + TABLE_RESPONSE_FILTERS;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);

        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {
                ResponseFilter responseFilter = new ResponseFilter();
                responseFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
                responseFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
                responseFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                responseFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));

                responseFilters.add(responseFilter);
            } while (c.moveToNext());
        }

        return responseFilters;
    }

    public List<ResponseFilter> getAllUserResponseFilters() {
        List<ResponseFilter> responseFilters = new ArrayList<ResponseFilter>();
        String selectQuery = "SELECT  * FROM " + TABLE_RESPONSE_FILTERS + " WHERE " + KEY_SOURCE + " IS NULL ";

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);

        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {
                ResponseFilter responseFilter = new ResponseFilter();
                responseFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
                responseFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
                responseFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                responseFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));

                responseFilters.add(responseFilter);
            } while (c.moveToNext());
        }

        return responseFilters;
    }


    public List<FilterFile> getAllResponseFilterFiles() {
        List<FilterFile> filterFiles = new ArrayList<>();
        String selectQuery = "SELECT " + KEY_SOURCE + ", COUNT(*) AS " + KEY_COUNT + " FROM " + TABLE_RESPONSE_FILTERS
                + " WHERE " + KEY_SOURCE + " IS NOT NULL GROUP BY " + KEY_SOURCE;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);
        Log.e("tag", selectQuery);
        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {

                FilterFile filterFile = new FilterFile();
                filterFile.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                filterFile.setFilterCount(c.getInt(c.getColumnIndex(KEY_COUNT)));
                Log.e("tag", filterFile.toString());
                Log.e("tag", filterFile.getTitle());
                filterFiles.add(filterFile);
            } while (c.moveToNext());
        }

        return filterFiles;
    }


    public List<String> getAllResponseFiltersForSource(String source) {
        List<String> filters = new ArrayList<>();
        String selectQuery = "SELECT " + KEY_CONTENT + " FROM " + TABLE_RESPONSE_FILTERS
                + " WHERE " + KEY_SOURCE + " = ?";
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, new String[]{source});

        int count = 0;

        if (c.moveToFirst()) {
            do {
                filters.add(c.getString(c.getColumnIndex(KEY_CONTENT)));
                count++;
            } while (c.moveToNext() && count < LIMIT);
        }

        if (count == LIMIT) {
            filters.add("--- Omitted " + (c.getCount() - LIMIT) + " entries ---");
        }

        return filters;
    }


    public int getResponseFilterCount() {
        String countQuery = "SELECT  * FROM " + TABLE_RESPONSE_FILTERS;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(countQuery, null);

        int count = cursor.getCount();
        cursor.close();

        // return count
        return count;
    }

    public int updateResponseFilter(ResponseFilter responseFilter) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put(KEY_CONTENT, responseFilter.getContent().trim());
        values.put(KEY_SOURCE, responseFilter.getSource());
        values.put(KEY_MODIFIED, getDateTime());

        // updating row
        return db.update(TABLE_RESPONSE_FILTERS, values, KEY_ID + " = ?",
                new String[]{String.valueOf(responseFilter.getId())});
    }

    /*
     * Deleting
     */
    public int deleteResponseFilter(ResponseFilter responseFilter) {
        return deleteResponseFilter(responseFilter.getId());
    }

    public int deleteResponseFilter(long id) {
        SQLiteDatabase db = this.getWritableDatabase();
        return db.delete(TABLE_RESPONSE_FILTERS, KEY_ID + " = ?",
                new String[]{String.valueOf(id)});
    }

    public int deleteResponseFilterFile(FilterFile filterFile) {
        return deleteResponseFilterFile(filterFile.getSource());
    }

    public int deleteResponseFilterFile(String source) {
        SQLiteDatabase db = this.getWritableDatabase();
        return db.delete(TABLE_RESPONSE_FILTERS, KEY_SOURCE + " = ?",
                new String[]{source});
    }

     /*
    ------------------------------------------------------------------
    Domain Filters
    ------------------------------------------------------------------
     */

    public int createDomainFilter(DomainFilter domainFilter) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put(KEY_CONTENT, domainFilter.getContent().trim());
        values.put(KEY_SOURCE, domainFilter.getSource());
        values.put(KEY_WILDCARD, domainFilter.getWildcard());
        values.put(KEY_MODIFIED, getDateTime());

        // insert row
        int id = (int) db.insert(TABLE_DOMAIN_FILTERS, null, values);

        return id;
    }

    public DomainFilter getDomainFilter(long id) {
        SQLiteDatabase db = this.getReadableDatabase();

        String selectQuery = "SELECT  * FROM " + TABLE_DOMAIN_FILTERS + " WHERE "
                + KEY_ID + " = " + id;


        Cursor c = db.rawQuery(selectQuery, null);

        if (c != null)
            c.moveToFirst();

        DomainFilter domainFilter = new DomainFilter();
        domainFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
        domainFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
        domainFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
        domainFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));
        domainFilter.setWildcard((c.getInt(c.getColumnIndex(KEY_WILDCARD))));

        return domainFilter;
    }

    public List<DomainFilter> getAllDomainFilters() {
        List<DomainFilter> domainFilters = new ArrayList<>();
        String selectQuery = "SELECT  * FROM " + TABLE_DOMAIN_FILTERS;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);

        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {
                DomainFilter domainFilter = new DomainFilter();
                domainFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
                domainFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
                domainFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                domainFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));
                domainFilter.setWildcard((c.getInt(c.getColumnIndex(KEY_WILDCARD))));
                domainFilters.add(domainFilter);
            } while (c.moveToNext());
        }

        return domainFilters;
    }

    public List<DomainFilter> getAllUserDomainFilters() {
        List<DomainFilter> domainFilters = new ArrayList<DomainFilter>();
        String selectQuery = "SELECT  * FROM " + TABLE_DOMAIN_FILTERS + " WHERE " + KEY_SOURCE + " IS NULL ";

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);

        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {
                DomainFilter domainFilter = new DomainFilter();
                domainFilter.setId(c.getInt(c.getColumnIndex(KEY_ID)));
                domainFilter.setContent((c.getString(c.getColumnIndex(KEY_CONTENT))));
                domainFilter.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                domainFilter.setModified(c.getString(c.getColumnIndex(KEY_MODIFIED)));
                domainFilter.setWildcard((c.getInt(c.getColumnIndex(KEY_WILDCARD))));
                domainFilters.add(domainFilter);
            } while (c.moveToNext());
        }

        return domainFilters;
    }


    public List<FilterFile> getAllDomainFilterFiles() {
        List<FilterFile> filterFiles = new ArrayList<>();
        String selectQuery = "SELECT " + KEY_SOURCE + ", COUNT(*) AS " + KEY_COUNT + " FROM " + TABLE_DOMAIN_FILTERS
                + " WHERE " + KEY_SOURCE + " IS NOT NULL GROUP BY " + KEY_SOURCE;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, null);
        if (c.moveToFirst()) {
            do {

                FilterFile filterFile = new FilterFile();
                filterFile.setSource((c.getString(c.getColumnIndex(KEY_SOURCE))));
                filterFile.setFilterCount(c.getInt(c.getColumnIndex(KEY_COUNT)));
                filterFiles.add(filterFile);
            } while (c.moveToNext());
        }

        return filterFiles;
    }


    public List<String> getAllDomainFiltersForSource(String source) {
        List<String> filters = new ArrayList<>();
        String selectQuery = "SELECT " + KEY_CONTENT + " FROM " + TABLE_DOMAIN_FILTERS
                + " WHERE " + KEY_SOURCE + " = ?";
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, new String[]{source});

        int count = 0;

        // looping through all rows and adding to list
        if (c.moveToFirst()) {
            do {
                filters.add(c.getString(c.getColumnIndex(KEY_CONTENT)));
                count++;
            } while (c.moveToNext() && count < LIMIT);
        }

        if (count == LIMIT) {
            filters.add("--- Omitted " + (c.getCount() - LIMIT) + " entries ---");
        }
        return filters;
    }

    //https://stackoverflow.com/questions/5451285/sqlite-select-query-with-like-condition-in-reverse
    public boolean isDomainBlocked(String domain) {
        String selectQuery = "SELECT * FROM " + TABLE_DOMAIN_FILTERS
                + " WHERE ( " + KEY_WILDCARD + " = 0 AND " + KEY_CONTENT + " = ?  ) OR ( " + KEY_WILDCARD + " = 1 AND ? LIKE '%' || " + KEY_CONTENT + " )";
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(selectQuery, new String[]{domain, domain});
        int count = c.getCount();
        c.close();
        return (count > 0);
    }


    public int getDomainFilterCount() {
        String countQuery = "SELECT  * FROM " + TABLE_DOMAIN_FILTERS;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(countQuery, null);

        int count = cursor.getCount();
        cursor.close();

        // return count
        return count;
    }

    public int updateDomainFilter(DomainFilter domainFilter) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put(KEY_CONTENT, domainFilter.getContent().trim());
        values.put(KEY_SOURCE, domainFilter.getSource());
        values.put(KEY_WILDCARD, domainFilter.getWildcard());
        values.put(KEY_MODIFIED, getDateTime());

        // updating row
        return db.update(TABLE_DOMAIN_FILTERS, values, KEY_ID + " = ?",
                new String[]{String.valueOf(domainFilter.getId())});
    }

    /*
     * Deleting a filter
     */
    public int deleteDomainFilter(DomainFilter domainFilter) {
        return deleteDomainFilter(domainFilter.getId());
    }

    public int deleteDomainFilter(long id) {
        SQLiteDatabase db = this.getWritableDatabase();
        return db.delete(TABLE_DOMAIN_FILTERS, KEY_ID + " = ?",
                new String[]{String.valueOf(id)});
    }

    public int deleteDomainFilterFile(FilterFile filterFile) {
        return deleteDomainFilterFile(filterFile.getSource());
    }

    public int deleteDomainFilterFile(String source) {
        SQLiteDatabase db = this.getWritableDatabase();
        return db.delete(TABLE_DOMAIN_FILTERS, KEY_SOURCE + " = ?",
                new String[]{source});
    }


    /**
     * get datetime
     */
    private String getDateTime() {
        SimpleDateFormat dateFormat = new SimpleDateFormat(
                "yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        Date date = new Date();
        return dateFormat.format(date);
    }


}