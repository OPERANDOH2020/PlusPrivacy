package eu.operando.models;

import java.io.Serializable;

/**
 * Created by Edy on 10/26/2016.
 */

public class PFBObject implements Serializable {

    private String description;
    private String endDate;
    private String logo;
    private String name;
    private String offerId;
    private String startDate;
    private boolean subscribed;
    private String userId;
    private String voucher;
    private String website;

    public PFBObject(String description, String endDate, String logo, String name, String offerId, String startDate, boolean subscribed, String userId, String voucher, String website) {
        this.description = description;
        this.endDate = endDate;
        this.logo = logo;
        this.name = name;
        this.offerId = offerId;
        this.startDate = startDate;
        this.subscribed = subscribed;
        this.userId = userId;
        this.voucher = voucher;
        this.website = website;
    }

    @Override
    public String toString() {
        return "PFBObject{" +
                "description='" + description + '\'' +
                ", endDate='" + endDate + '\'' +
                ", logo='" + logo + '\'' +
                ", name='" + name + '\'' +
                ", offerId='" + offerId + '\'' +
                ", startDate='" + startDate + '\'' +
                ", subscribed=" + subscribed +
                ", userId='" + userId + '\'' +
                ", voucher='" + voucher + '\'' +
                ", website='" + website + '\'' +
                '}';
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setOfferId(String offerId) {
        this.offerId = offerId;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public void setSubscribed(boolean subscribed) {
        this.subscribed = subscribed;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setVoucher(String voucher) {
        this.voucher = voucher;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getDescription() {
        return description;
    }

    public String getEndDate() {
        return endDate;
    }

    public String getLogo() {
        return logo;
    }

    public String getName() {
        return name;
    }

    public String getOfferId() {
        return offerId;
    }

    public String getStartDate() {
        return startDate;
    }

    public boolean isSubscribed() {
        return subscribed;
    }

    public String getUserId() {
        return userId;
    }

    public String getVoucher() {
        return voucher;
    }

    public String getWebsite() {
        return website;
    }
}
