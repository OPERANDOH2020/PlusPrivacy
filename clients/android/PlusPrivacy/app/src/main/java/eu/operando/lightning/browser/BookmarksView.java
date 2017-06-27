package eu.operando.lightning.browser;

import android.support.annotation.NonNull;

import eu.operando.lightning.database.HistoryItem;

public interface BookmarksView {

    void navigateBack();

    void handleUpdatedUrl(@NonNull String url);

    void handleBookmarkDeleted(@NonNull HistoryItem item);

}
