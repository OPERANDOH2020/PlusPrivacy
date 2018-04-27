package eu.operando.models;

import java.util.Map;
import java.util.TreeMap;

import eu.operando.R;

/**
 * Created by Alex on 1/18/2018.
 */

public enum SocialNetworkEnum {

    FACEBOOK("facebook", R.color.social_network_settings_facebook, R.color.background_facebook_child_item, R.string.facebook_privacy_settings),
    LINKEDIN("linkedin", R.color.social_network_settings_linkedin, R.color.social_network_settings_linkedin_child, R.string.linkedin_privacy_settings),
    TWITTER("twitter", R.color.social_network_settings_twitter, R.color.social_network_settings_twitter_child, R.string.twitter_privacy_settings),
    GOOGLE("google", R.color.social_network_settings_google, R.color.social_network_settings_google_child, R.string.google_privacy_settings);

    private static Map<Integer, SocialNetworkEnum> treeMap = new TreeMap<>();
    private int value;
    private String id;
    private int color;
    private int childColor;
    private int toolbarTitle;

    static {
        for (int i = 0; i < values().length; i++) {
            values()[i].value = i;
            treeMap.put(values()[i].value, values()[i]);
        }
    }

    SocialNetworkEnum(String id, int color, int childColor, int toolbarTitle) {
        this.id = id;
        this.color = color;
        this.childColor = childColor;
        this.toolbarTitle = toolbarTitle;
    }

    public String getId(){
        return id;
    }

    public int getColor() {
        return color;
    }

    public int getChildColor() {
        return childColor;
    }

    public int getToolbarTitle() {
        return toolbarTitle;
    }
}