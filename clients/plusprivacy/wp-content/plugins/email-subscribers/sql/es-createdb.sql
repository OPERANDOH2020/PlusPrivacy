CREATE TABLE IF NOT EXISTS es_emaillist (
  es_email_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_email_name VARCHAR(255) NOT NULL,
  es_email_mail VARCHAR(255) NOT NULL,
  es_email_status VARCHAR(25) NOT NULL default 'Unconfirmed',
  es_email_created datetime NOT NULL default '0000-00-00 00:00:00',
  es_email_viewcount VARCHAR(100) NOT NULL,
  es_email_group VARCHAR(255) NOT NULL default 'Public',
  es_email_guid VARCHAR(255) NOT NULL,
  PRIMARY KEY  (es_email_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;

-- SQLQUERY ---

CREATE TABLE IF NOT EXISTS es_templatetable (
  es_templ_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_templ_heading VARCHAR(255) NOT NULL,
  es_templ_body TEXT NULL,
  es_templ_status VARCHAR(25) NOT NULL default 'Published',
  es_email_type VARCHAR(100) NOT NULL default 'Newsletter',
  PRIMARY KEY  (es_templ_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;

-- SQLQUERY ---

CREATE TABLE IF NOT EXISTS es_notification (
  es_note_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_note_cat TEXT NULL,
  es_note_group VARCHAR(255) NOT NULL,
  es_note_templ INT unsigned NOT NULL,
  es_note_status VARCHAR(10) NOT NULL default 'Enable',
  PRIMARY KEY  (es_note_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;

-- SQLQUERY ---

CREATE TABLE IF NOT EXISTS es_sentdetails (
  es_sent_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_sent_guid VARCHAR(255) NOT NULL,
  es_sent_qstring VARCHAR(255) NOT NULL,
  es_sent_source VARCHAR(255) NOT NULL,
  es_sent_starttime datetime NOT NULL default '0000-00-00 00:00:00',
  es_sent_endtime datetime NOT NULL default '0000-00-00 00:00:00',
  es_sent_count INT unsigned NOT NULL,
  es_sent_preview TEXT NULL,
  es_sent_status VARCHAR(25) NOT NULL default 'Sent',
  es_sent_type VARCHAR(25) NOT NULL default 'Immediately',
  es_sent_subject VARCHAR(255) NOT NULL,
  PRIMARY KEY  (es_sent_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;

-- SQLQUERY ---

CREATE TABLE IF NOT EXISTS es_deliverreport (
  es_deliver_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_deliver_sentguid VARCHAR(255) NOT NULL,
  es_deliver_emailid INT unsigned NOT NULL,
  es_deliver_emailmail VARCHAR(255) NOT NULL,
  es_deliver_sentdate datetime NOT NULL default '0000-00-00 00:00:00',
  es_deliver_status VARCHAR(25) NOT NULL,
  es_deliver_viewdate datetime NOT NULL default '0000-00-00 00:00:00',
  es_deliver_sentstatus VARCHAR(25) NOT NULL default 'Sent',
  es_deliver_senttype VARCHAR(25) NOT NULL default 'Immediately',
  PRIMARY KEY  (es_deliver_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;

-- SQLQUERY ---

CREATE TABLE IF NOT EXISTS es_pluginconfig (
  es_c_id INT unsigned NOT NULL AUTO_INCREMENT,
  es_c_fromname VARCHAR(255) NOT NULL,
  es_c_fromemail VARCHAR(255) NOT NULL,
  es_c_mailtype VARCHAR(255) NOT NULL,
  es_c_adminmailoption VARCHAR(255) NOT NULL,
  es_c_adminemail VARCHAR(255) NOT NULL,
  es_c_adminmailsubject VARCHAR(255) NOT NULL,
  es_c_adminmailcontant TEXT NULL,
  es_c_usermailoption VARCHAR(255) NOT NULL,
  es_c_usermailsubject VARCHAR(255) NOT NULL,
  es_c_usermailcontant TEXT NULL,
  es_c_optinoption VARCHAR(255) NOT NULL,
  es_c_optinsubject VARCHAR(255) NOT NULL,
  es_c_optincontent TEXT NULL,
  es_c_optinlink VARCHAR(255) NOT NULL,
  es_c_unsublink  VARCHAR(255) NOT NULL,
  es_c_unsubtext TEXT NULL,
  es_c_unsubhtml TEXT NULL,
  es_c_subhtml TEXT NULL,
  es_c_message1 TEXT NULL,
  es_c_message2 TEXT NULL,
  PRIMARY KEY  (es_c_id)
) ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;