package eu.operando.models.privacysettings;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Matei_Alexandru on 04.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class Question implements Serializable{
    private Read read;
    private String tag;
    private Write write;

    public Question(Read read, String tag, Write write) {
        this.read = read;
        this.tag = tag;
        this.write = write;
    }

    public Write getWrite() {
        return write;
    }

    public void setWrite(Write write) {
        this.write = write;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public Read getRead() {
        return read;
    }

    public void setRead(Read read) {
        this.read = read;
    }

    public class Read implements Serializable{
        private String name;
        private String url;
        private List<AvailableSettings> availableSettings;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public List<AvailableSettings> getAvailableSettings() {
            return availableSettings;
        }

        public void setAvailableSettings(List<AvailableSettings> availableSettings) {
            this.availableSettings = availableSettings;
        }

        public Read(String name, String url, List<AvailableSettings> availableSettings) {
            this.name = name;
            this.url = url;
            this.availableSettings = availableSettings;
        }
    }
}