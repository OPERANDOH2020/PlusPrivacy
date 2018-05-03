package eu.operando.androidsdk.semanticfirewall.model;

import android.arch.persistence.room.Dao;
import android.arch.persistence.room.Delete;
import android.arch.persistence.room.Insert;
import android.arch.persistence.room.Query;

import java.util.List;

/**
 * Created by Alex on 03.05.2018.
 */

@Dao
public interface FirewallLogDao {

    @Query("SELECT * FROM FirewallLog")
    public List<FirewallLog> getAll();


    @Query("SELECT * FROM FirewallLog WHERE name LIKE :first")
    FirewallLog findByName(String first);

    @Insert
    void insertAll(FirewallLog... log);

    @Insert
    void insert(FirewallLog log);

    @Delete
    void delete(FirewallLog log);


}
