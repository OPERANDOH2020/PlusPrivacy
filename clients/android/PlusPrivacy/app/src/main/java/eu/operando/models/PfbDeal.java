package eu.operando.models;

/**
 * Created by Matei_Alexandru on 05.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class PfbDeal {

    private String id;
    private String userId;
    private String pfbId;
    private String voucher;
    private String accepted_date;

    public PfbDeal(String id, String userId, String pfbId, String voucher, String accepted_date) {
        this.id = id;
        this.userId = userId;
        this.pfbId = pfbId;
        this.voucher = voucher;
        this.accepted_date = accepted_date;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPfbId() {
        return pfbId;
    }

    public void setPfbId(String pfbId) {
        this.pfbId = pfbId;
    }

    public String getVoucher() {
        return voucher;
    }

    public void setVoucher(String voucher) {
        this.voucher = voucher;
    }

    public String getAccepted_date() {
        return accepted_date;
    }

    public void setAccepted_date(String accepted_date) {
        this.accepted_date = accepted_date;
    }

    @Override
    public String toString() {
        return "PfbDeal{" +
                "id='" + id + '\'' +
                ", userId='" + userId + '\'' +
                ", pfbId='" + pfbId + '\'' +
                ", voucher='" + voucher + '\'' +
                ", accepted_date='" + accepted_date + '\'' +
                '}';
    }
}