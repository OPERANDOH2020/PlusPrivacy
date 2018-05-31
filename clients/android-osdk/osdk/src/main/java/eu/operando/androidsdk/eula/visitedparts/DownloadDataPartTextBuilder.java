package eu.operando.androidsdk.eula.visitedparts;

import java.util.List;

import eu.operando.androidsdk.eula.visitor.ITextBuilderVisitor;
import eu.operando.androidsdk.scdmodel.ScdModel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class DownloadDataPartTextBuilder implements ITextBuilderPart{

    private ScdModel scd;

    public DownloadDataPartTextBuilder(ScdModel scd) {
        this.scd = scd;
    }

    public String build() {
        if (scd.getAccessedHosts().getHostList() != null) {
            return buildHostListPart(scd.getAccessedHosts().getHostList());
        }

        if (scd.getAccessedHosts().getReasonNonDisclosure() != null) {
            return buildReasonNonDisclosurePart(scd.getAccessedHosts().getReasonNonDisclosure());
        }

        return null;
    }

    private String buildHostListPart(List<String> hostList) {
        final String ACCESSED_HOST_LIST_PART = "The app downloads data from the following third " +
                "party sources:\n";
        StringBuilder hostListSb = new StringBuilder(ACCESSED_HOST_LIST_PART);
        for (String host : hostList) {
            hostListSb.append(host);
            hostListSb.append("\n");
        }

        final String ACCESSED_HOST_LIST_PART_2 = "\n\nDownloading data may be based on your" +
                " input, for example a search keyword that you type in a text field. You should" +
                " isSecure the app's Privacy Policy to see whether this data is tracked and / or " +
                "how it is used.";
        hostListSb.append(ACCESSED_HOST_LIST_PART_2);
        return hostListSb.toString();
    }

    private String buildReasonNonDisclosurePart(String reasonNonDisclosure) {
        final String REASON_NON_DISCLOSURE_PART = "The app does not list the accessed hosts, " +
                "for the following reason(s):\n";
        return REASON_NON_DISCLOSURE_PART + reasonNonDisclosure + "\n";
    }

    @Override
    public void accept(ITextBuilderVisitor textBuilderVisitor) {
        textBuilderVisitor.visit(this);
    }
}
