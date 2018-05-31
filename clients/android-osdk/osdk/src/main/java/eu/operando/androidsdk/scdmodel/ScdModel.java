package eu.operando.androidsdk.scdmodel;

import java.util.List;

/**
 * Created by Matei_Alexandru on 11.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class ScdModel {
    private String title;
    private String bundleId;
    private AccessedHosts accessedHosts;
    private List<AccessedInputs> accessedInputs;

    public ScdModel(String title, String bundleId, AccessedHosts accessedHosts,
                    List<AccessedInputs> accessedInputs) {
        this.title = title;
        this.bundleId = bundleId;
        this.accessedHosts = accessedHosts;
        this.accessedInputs = accessedInputs;
    }

    public String getTitle() {
        return title;
    }

    public String getBundleId() {
        return bundleId;
    }

    public AccessedHosts getAccessedHosts() {
        return accessedHosts;
    }

    public List<AccessedInputs> getAccessedInputs() {
        return accessedInputs;
    }

    public class AccessedHosts {
        private String reasonNonDisclosure;
        private List<String> hostList;

        public AccessedHosts(String reasonNonDisclosure, List<String> hostList) {
            this.reasonNonDisclosure = reasonNonDisclosure;
            this.hostList = hostList;
        }

        @Override
        public String toString() {
            return "AccessedHosts{" +
                    "reasonNonDisclosure='" + reasonNonDisclosure + '\'' +
                    ", hostList=" + hostList +
                    '}';
        }

        public List<String> getHostList() {
            return hostList;
        }

        public String getReasonNonDisclosure() {
            return reasonNonDisclosure;
        }

    }

    public class AccessedInputs {
        private String inputType;
        private PrivacyDescription privacyDescription;
        private String accessFrequency;
        private String userControl;

        public AccessedInputs(String inputType, PrivacyDescription privacyDescription,
                              String accessFrequency, String userControl) {
            this.inputType = inputType;
            this.privacyDescription = privacyDescription;
            this.accessFrequency = accessFrequency;
            this.userControl = userControl;
        }

        public String getInputType() {
            return inputType;
        }

        public PrivacyDescription getPrivacyDescription() {
            return privacyDescription;
        }

        public String getAccessFrequency() {
            return accessFrequency;
        }

        public String getUserControl() {
            return userControl;
        }

        public class PrivacyDescription {
            private int usageLevel;
            private List<ThirdParty> thirdParties;

            public PrivacyDescription(int usageLevel, List<ThirdParty> thirdParties) {
                this.usageLevel = usageLevel;
                this.thirdParties = thirdParties;
            }

            public int getUsageLevel() {
                return usageLevel;
            }

            public List<ThirdParty> getThirdParties() {
                return thirdParties;
            }

            @Override
            public String toString() {
                return "PrivacyDescription{" +
                        "usageLevel=" + usageLevel +
                        ", thirdParties=" + thirdParties +
                        '}';
            }

            public class ThirdParty {

                private String name;
                private String url;

                public ThirdParty(String name, String url) {
                    this.name = name;
                    this.url = url;
                }

                public String getName() {
                    return name;
                }

                public String getUrl() {
                    return url;
                }

                @Override
                public String toString() {
                    return "ThirdParty{" +
                            "name='" + name + '\'' +
                            ", url='" + url + '\'' +
                            '}';
                }
            }
        }

        @Override
        public String toString() {
            return "AccessedInputs{" +
                    "inputType='" + inputType + '\'' +
                    ", privacyDescription=" + privacyDescription +
                    ", accessFrequency='" + accessFrequency + '\'' +
                    ", userControl='" + userControl + '\'' +
                    '}';
        }
    }

    @Override
    public String toString() {
        return "ScdModel{" +
                "title='" + title + '\'' +
                ", bundleId='" + bundleId + '\'' +
                ", accessedHosts=" + accessedHosts +
                ", accessedInputs=" + accessedInputs +
                '}';
    }
}