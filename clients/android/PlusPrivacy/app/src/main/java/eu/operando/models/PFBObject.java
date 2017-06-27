package eu.operando.models;

/**
 * Created by Edy on 10/26/2016.
 */

public class PFBObject {
    public int getServiceId() {
        return serviceId;
    }

    public String getWebsite() {
        return website;
    }

    public String getBenefit() {
        return benefit;
    }

    public String getIdentifier() {
        return identifier;
    }

    public String getDescription() {
        return description;
    }

    public String getLogo() {
        return logo;
    }

    public String getVoucher() {
        return voucher;
    }

    public boolean isSubscribed() {
        return subscribed;
    }

    private int serviceId;
    private String website;
    private String benefit;
    private String identifier;
    private String description;
    private String logo;
    private String voucher;
    private boolean subscribed;


}
