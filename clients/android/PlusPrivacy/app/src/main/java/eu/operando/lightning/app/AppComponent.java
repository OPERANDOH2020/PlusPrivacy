package eu.operando.lightning.app;

import javax.inject.Singleton;

import eu.operando.BrowserApp;
import eu.operando.activity.SettingsActivity;
import eu.operando.lightning.activity.BrowserActivity;
import eu.operando.lightning.activity.ReadingActivity;
import eu.operando.lightning.activity.TabsManager;
import eu.operando.lightning.activity.ThemableBrowserActivity;
import eu.operando.lightning.activity.ThemableSettingsActivity;
import eu.operando.lightning.browser.BrowserPresenter;
import eu.operando.lightning.constant.BookmarkPage;
import eu.operando.lightning.constant.HistoryPage;
import eu.operando.lightning.constant.StartPage;
import eu.operando.lightning.database.history.HistoryDatabase;
import eu.operando.lightning.dialog.LightningDialogBuilder;
import eu.operando.lightning.download.LightningDownloadListener;
import eu.operando.lightning.fragment.BookmarkSettingsFragment;
import eu.operando.lightning.fragment.BookmarksFragment;
import eu.operando.lightning.fragment.DebugSettingsFragment;
import eu.operando.lightning.fragment.LightningPreferenceFragment;
import eu.operando.lightning.fragment.PrivacySettingsFragment;
import eu.operando.lightning.fragment.TabsFragment;
import eu.operando.lightning.search.SuggestionsAdapter;
import eu.operando.lightning.view.AdblockWebClient;
import eu.operando.lightning.view.LightningChromeClient;
import eu.operando.lightning.view.LightningView;
import dagger.Component;

@Singleton
@Component(modules = {AppModule.class})
public interface AppComponent {

    void inject(BrowserActivity activity);

    void inject(BookmarksFragment fragment);

    void inject(BookmarkSettingsFragment fragment);

    void inject(LightningDialogBuilder builder);

    void inject(TabsFragment fragment);

    void inject(LightningView lightningView);

    void inject(ThemableBrowserActivity activity);

    void inject(LightningPreferenceFragment fragment);

    void inject(BrowserApp app);

    void inject(ReadingActivity activity);

    void inject(AdblockWebClient webClient);

    void inject(ThemableSettingsActivity activity);

    void inject(LightningDownloadListener listener);

    void inject(PrivacySettingsFragment fragment);

    void inject(StartPage startPage);

    void inject(HistoryPage historyPage);

    void inject(BookmarkPage bookmarkPage);

    void inject(BrowserPresenter presenter);

    void inject(TabsManager manager);

    void inject(DebugSettingsFragment fragment);

    void inject(SuggestionsAdapter suggestionsAdapter);

    void inject(LightningChromeClient chromeClient);

    void inject(SettingsActivity settingsActivity);

    HistoryDatabase historyDatabase();

}
