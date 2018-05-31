{
    "facebook": {
        "who_can_see_future_posts": {
            "read": {
                "name": "Who can see your future posts?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "public": {
                        "name": "Public",
                        "index": 0
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 1
                    },
                    "only_me": {
                        "name": "Only Me",
                        "index": 2
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see your future posts?",
                "page": "https://www.facebook.com/settings?tab=privacy&section=composer&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=privacy_settings_composer_preview&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "public": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 0
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Public"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 0
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    },
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 0
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    }
                },
                "data": {},
                "recommended": "friends"
            },
            "tags": [
                "exposure"
            ],
            "id": 0
        },
        "who_can_see_friends": {
            "read": {
                "name": "Who can see your friends list?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "public": {
                        "name": "Public",
                        "index": 3
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 4
                    },
                    "friends_except_acquaintances": {
                        "name": "Friends except Acquaintances",
                        "index": 5
                    },
                    "only_me": {
                        "name": "Only Me",
                        "index": 6
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(0) .fbSettingsListItem:eq(1) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see your friends list?",
                "page": "https://www.facebook.com/settings?tab=privacy&section=friendlist&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "public": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787365733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Public"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787365733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    },
                    "friends_except_acquaintances": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787365733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 284920934947802
                            }
                        },
                        "name": "Friends except Acquaintances"
                    },
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787365733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    }
                },
                "data": {},
                "recommended": "only_me"
            },
            "tags": [
                "exposure",
                "contact"
            ],
            "id": 1
        },
        "who_can_contact": {
            "read": {
                "name": "Who can contact you/send you friend requests?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "everyone": {
                        "name": "Everyone",
                        "index": 7
                    },
                    "friends_of_friends": {
                        "name": "Friends of Friends",
                        "index": 8
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can contact me?",
                "page": "https://www.facebook.com/settings?tab=privacy&section=canfriend&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                "availableSettings": {
                    "everyone": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787540733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Everyone"
                    },
                    "friends_of_friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787540733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 275425949243301
                            }
                        },
                        "name": "Friends of Friends"
                    }
                },
                "data": {},
                "recommended": "friends_of_friends"
            },
            "id": 2
        },
        "lookup_email": {
            "read": {
                "name": "Who can look you up using your email address?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "everyone": {
                        "name": "Everyone",
                        "index": 9
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 10
                    },
                    "friends_of_friends": {
                        "name": "Friends of Friends",
                        "index": 11
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(2) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can look me up by email address",
                "page": "https://www.facebook.com/settings?tab=privacy&section=findemail&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                "availableSettings": {
                    "everyone": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787820733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Everyone"
                    },
                    "friends_of_friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787820733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 275425949243301
                            }
                        },
                        "name": "Friends of Friends"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787820733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    }
                },
                "data": {},
                "recommended": "friends"
            },
            "tags": [
                "contact",
                "discovery",
                "control"
            ],
            "id": 3
        },
        "lookup_phone": {
            "read": {
                "name": "Who can look you up using the phone number you provided?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "everyone": {
                        "name": "Everyone",
                        "index": 12
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 13
                    },
                    "friends_of_friends": {
                        "name": "Friends of Friends",
                        "index": 14
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can look me up by phone",
                "page": "https://www.facebook.com/settings?tab=privacy&section=findphone&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                "availableSettings": {
                    "everyone": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787815733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Everyone"
                    },
                    "friends_of_friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787815733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 275425949243301
                            }
                        },
                        "name": "Friends of Friends"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787815733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    }
                },
                "data": {},
                "recommended": "friends"
            },
            "tags": [
                "contact",
                "discovery",
                "control"
            ],
            "id": 4
        },
        "search_engine": {
            "read": {
                "name": "Allow engines outside Facebook to link to your profile?",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 15
                    },
                    "no": {
                        "name": "No",
                        "index": 16
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(2) .fbSettingsListItem:eq(2) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can look me up by search engines?",
                "page": "https://www.facebook.com/settings?tab=privacy&section=search&view",
                "url_template": "https://www.facebook.com/ajax/settings_page/search_filters.php?dpr=1",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "el": "search_filter_public",
                            "public": 1
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "el": "search_filter_public",
                            "public": 0
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "no"
            },
            "tags": [
                "contact",
                "discovery",
                "control"
            ],
            "id": 5
        },
        "limit_timeline": {
            "read": {
                "name": "Who can add things to your timeline?",
                "url": "https://www.facebook.com/settings?tab=timeline",
                "availableSettings": {
                    "only_me": {
                        "name": "Only Me",
                        "index": 17
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 18
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can add things to your timeline?",
                "page": "https://www.facebook.com/settings?tab=timeline&section=posting&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 10153940308610734
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 10153940308610734
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    }
                },
                "data": {},
                "recommended": "only_me"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 6
        },
        "control_timeline": {
            "read": {
                "name": "Review tags people add to your own posts before the tags appear on Facebook",
                "url": "https://www.facebook.com/settings?tab=timeline",
                "availableSettings": {
                    "enabled": {
                        "name": "On",
                        "index": 19
                    },
                    "disabled": {
                        "name": "Off",
                        "index": 20
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(0) .fbSettingsListItem:eq(1) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Review tags people add to your own posts before the tags appear on Facebook",
                "page": "https://www.facebook.com/settings?tab=timeline&section=review&view",
                "url_template": "https://www.facebook.com/ajax/settings/tagging/review.php?dpr=1",
                "availableSettings": {
                    "enabled": {
                        "data": {
                            "tag_review_enabled": 1
                        },
                        "name": "On"
                    },
                    "disabled": {
                        "data": {
                            "tag_review_enabled": 0
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "enabled"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 7
        },
        "timeline_posts_tags": {
            "read": {
                "name": "Who can see posts you've been tagged in on your timeline?",
                "url": "https://www.facebook.com/settings?tab=timeline",
                "availableSettings": {
                    "everyone": {
                        "name": "Everyone",
                        "index": 21
                    },
                    "friends_of_friends": {
                        "name": "Friends of Friends",
                        "index": 22
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 23
                    },
                    "friends_except_acquaintances": {
                        "name": "Friends except Acquaintances",
                        "index": 24
                    },
                    "only_me": {
                        "name": "Only Me",
                        "index": 25
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(1) .fbSettingsListItem:eq(1) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see posts you've been tagged in on your timeline?",
                "page": "https://www.facebook.com/settings?tab=timeline&section=tagging&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "everyone": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787530733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Everyone"
                    },
                    "friends_of_friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787530733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 275425949243301
                            }
                        },
                        "name": "Friends of Friends"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787530733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    },
                    "friends_except_acquaintances": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787530733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 284920934947802
                            }
                        },
                        "name": "Friends except Acquaintances"
                    },
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787530733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    }
                },
                "recommended": "only_me"
            },
            "tags": [
                "exposure"
            ],
            "id": 8
        },
        "timeline_other_posts": {
            "read": {
                "name": "Who can see what others post on your timeline?",
                "url": "https://www.facebook.com/settings?tab=timeline",
                "availableSettings": {
                    "everyone": {
                        "name": "Everyone",
                        "index": 26
                    },
                    "friends_of_friends": {
                        "name": "Friends of Friends",
                        "index": 27
                    },
                    "friends": {
                        "name": "Friends",
                        "index": 28
                    },
                    "friends_except_acquaintances": {
                        "name": "Friends except Acquaintances",
                        "index": 29
                    },
                    "only_me": {
                        "name": "Only Me",
                        "index": 30
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(1) .fbSettingsListItem:eq(2) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see what others post on your timeline?",
                "page": "https://www.facebook.com/settings?tab=timeline&section=others&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "everyone": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787370733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 300645083384735
                            }
                        },
                        "name": "Everyone"
                    },
                    "friends_of_friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787370733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 275425949243301
                            }
                        },
                        "name": "Friends of Friends"
                    },
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787370733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    },
                    "friends_except_acquaintances": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787370733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 284920934947802
                            }
                        },
                        "name": "Friends except Acquaintances"
                    },
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787370733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    }
                },
                "recommended": "only_me"
            },
            "tags": [
                "exposure"
            ],
            "id": 9
        },
        "photo_tags_audience": {
            "read": {
                "name": "When you are tagged in a post, whom do you want to add to the audience if they are not already in it?",
                "url": "https://www.facebook.com/settings?tab=timeline",
                "availableSettings": {
                    "friends": {
                        "name": "Friends",
                        "index": 31
                    },
                    "only_me": {
                        "name": "Only Me",
                        "index": 32
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "When you are tagged in a post, whom do you want to add to the audience if they are not already in it?",
                "page": "https://www.facebook.com/settings?tab=timeline&section=expansion&view",
                "url_template": "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location_enum=settings&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                "availableSettings": {
                    "friends": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787795733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 291667064279714
                            }
                        },
                        "name": "Friends"
                    },
                    "only_me": {
                        "params": {
                            "privacy_fbid": {
                                "placeholder": "OPERANDO_PRIVACY_FBID",
                                "value": 8787795733
                            },
                            "post_param": {
                                "placeholder": "OPERANDO_POST_PARAM",
                                "value": 286958161406148
                            }
                        },
                        "name": "Only Me"
                    }
                },
                "recommended": "only_me"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 10
        },
        "control_followers": {
            "read": {
                "name": "Who can be your follower?",
                "url": "https://www.facebook.com/settings?tab=followers",
                "availableSettings": {
                    "friends": {
                        "name": "Friends",
                        "index": 33
                    },
                    "public": {
                        "name": "Public",
                        "index": 34
                    }
                },
                "jquery_selector": {
                    "element": "span[class='_55pe']",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who Can Follow Me",
                "url_template": "https://www.facebook.com/ajax/follow/enable_follow.php?dpr=1",
                "page": "https://www.facebook.com/settings?tab=followers",
                "availableSettings": {
                    "friends": {
                        "data": {
                            "allow_subscribers": "disallow",
                            "should_inject": ""
                        },
                        "name": "Friends"
                    },
                    "public": {
                        "data": {
                            "allow_subscribers": "allow",
                            "should_inject": 1
                        },
                        "name": "Public"
                    }
                },
                "data": {
                    "location": 44,
                    "hideable_ids": [
                        "#following_plugin_item"
                    ]
                },
                "recommended": "friends"
            },
            "tags": [
                "contact",
                "control",
                "exposure"
            ],
            "id": 11
        },
        "permissions_for_apps": {
            "read": {
                "name": "Set permissions for data access by the apps that you use",
                "url": "https://www.facebook.com/settings?tab=applications",
                "availableSettings": [
                    "Friends",
                    "Everyone"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Disable all permissions"
            }
        },
        "see_apps": {
            "read": {
                "name": "Control who on Facebook can see that you use this app",
                "url": "https://www.facebook.com/settings?tab=applications",
                "availableSettings": [
                    "Public",
                    "Friends of Friends",
                    "Friends",
                    "Only Me"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Limit to yourself"
            }
        },
        "allow_apps": {
            "read": {
                "name": "Allow use of apps, plugins, games and websites on Facebook and elsewhere?",
                "url": "https://www.facebook.com/settings?tab=applications",
                "availableSettings": {
                    "disabled": {
                        "name": "Disalow",
                        "index": 35
                    },
                    "enabled": {
                        "name": "Allow",
                        "index": 36
                    }
                },
                "jquery_selector": {
                    "element": "._3q72",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow use of apps, plugins, games and websites on Facebook and elsewhere?",
                "page": "https://www.facebook.com/settings?tab=applications",
                "url_template": "https://www.facebook.com/settings/application/platform_opt_out/submit/?action={ACTION}&dpr=1",
                "availableSettings": {
                    "enabled": {
                        "params": {
                            "action": {
                                "placeholder": "ACTION",
                                "value": "enable"
                            }
                        },
                        "name": "Enabled."
                    },
                    "disabled": {
                        "params": {
                            "action": {
                                "placeholder": "ACTION",
                                "value": "disable"
                            }
                        },
                        "name": "Disabled."
                    }
                },
                "recommended": "disabled"
            },
            "tags": [
                "applications",
                "control",
                "personal data"
            ],
            "id": 12
        },
        "control_personal_info": {
            "read": {
                "name": "Control what personal info of yours your friends can bring with them when they use apps, games and websites ",
                "url": "https://www.facebook.com/settings?tab=applications",
                "availableSettings": [
                    "Allow",
                    "Disallow"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Do not allow any"
            }
        },
        "control_outdated_clients": {
            "read": {
                "name": "Who will see things you post using old Facebook mobile apps that do not have the inline audience selector, such as outdated versions of Facebook for BlackBerry?",
                "url": "https://www.facebook.com/settings?tab=applications",
                "availableSettings": [
                    "Public",
                    "Friends of Friends",
                    "Friends",
                    "Only Me"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Limit to yourself"
            }
        },
        "control_ads": {
            "read": {
                "name": "Allow Facebook to show you ads based on your use of websites and apps that use Facebook's technologies ",
                "url": "https://www.facebook.com/settings?tab=ads",
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 37
                    },
                    "no": {
                        "name": "No",
                        "index": 38
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Ads based on my use of websites and apps",
                "page": "https://www.facebook.com/settings?tab=ads&section=oba&view",
                "url_template": "https://www.facebook.com/ads/preferences/oba/?dpr=1",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "is_opted_out": 0
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "is_opted_out": 1
                        },
                        "name": "No"
                    }
                },
                "recommended": "no"
            },
            "tags": [
                "advertising",
                "profiling",
                "personal data",
                "control"
            ],
            "id": 13
        },
        "facebook_companies_ads": {
            "read": {
                "name": "Can your Facebook ad preferences be used to show you ads on apps and websites of Facebook Companies?",
                "url": "https://www.facebook.com/settings?tab=ads&view",
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 39
                    },
                    "no": {
                        "name": "No",
                        "index": 40
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Can your Facebook ad preferences be used to show you ads on apps and websites of Facebook Companies?",
                "page": "https://www.facebook.com/settings?tab=ads&section=fpd&view",
                "url_template": "https://www.facebook.com/ads/preferences/fpd/?dpr=1",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "is_opted_out": 0
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "is_opted_out": 1
                        },
                        "name": "No"
                    }
                },
                "recommended": "no"
            },
            "tags": [
                "personal_data",
                "profiling",
                "advertising",
                "control"
            ],
            "id": 14
        },
        "control_friends_ads": {
            "read": {
                "name": "Who can see your social actions paired with ads?",
                "url": "https://www.facebook.com/settings?tab=ads",
                "availableSettings": {
                    "only_friends": {
                        "name": "Only my friends",
                        "index": 41
                    },
                    "no_one": {
                        "name": "No one",
                        "index": 42
                    }
                },
                "jquery_selector": {
                    "element": ".fbSettingsList:eq(2) .fbSettingsListItem:eq(0) ._nlm",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see your social actions paired with ads?",
                "page": "https://www.facebook.com/settings?tab=ads&section=socialcontext&view",
                "url_template": "https://www.facebook.com/ajax/settings/ads/socialcontext.php?dpr=1",
                "availableSettings": {
                    "only_friends": {
                        "data": {
                            "opt_out": ""
                        },
                        "name": "Only my friends"
                    },
                    "no_one": {
                        "data": {
                            "opt_out": 1
                        },
                        "name": "No one"
                    }
                },
                "recommended": "no_one"
            },
            "tags": [
                "personal data",
                "profiling",
                "advertising",
                "control",
                "exposure"
            ],
            "id": 15
        },
        "control_preferences": {
            "read": {
                "name": "Control preferences Facebook  created for you based on things like your profile information, actions you take on Facebook and websites and apps you use off Facebook ",
                "url": "https://www.facebook.com/settings?tab=ads",
                "availableSettings": [
                    "Remove all preferences",
                    "Allow"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Remove all preferences created by Facebook"
            }
        },
        "allow_email_share": {
            "read": {
                "name": "Allow or disallow friends to include your email address in \"download your information\"",
                "url": "https://www.facebook.com/settings?tab=privacy",
                "availableSettings": [
                    "Allow",
                    "Disallow"
                ],
                "jquery_selector": {}
            },
            "write": {
                "recommended": "Disallow"
            }
        }
    },
    "linkedin": {
        "control_profile_photo": {
            "read": {
                "name": "Control your profile photo and visibility.",
                "url": "https://www.linkedin.com/psettings/profile-photo-visibility",
                "availableSettings": {
                    "No_One": {
                        "name": "No One",
                        "index": 43
                    },
                    "Your_Connections": {
                        "name": "Your Connections",
                        "index": 44
                    },
                    "Your_Network": {
                        "name": "Your Network",
                        "index": 45
                    },
                    "Everyone": {
                        "name": "Everyone",
                        "index": 46
                    }
                },
                "jquery_selector": {
                    "element": "#setting-profile-photo-visibility .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Control your profile photo and visibility.",
                "page": "https://www.linkedin.com/psettings/profile-photo-visibility",
                "url_template": "https://www.linkedin.com/psettings/profile-photo-visibility",
                "type": "multipart/form-data",
                "availableSettings": {
                    "No_One": {
                        "data": {
                            "profilePhotoVisibility": "HIDE"
                        },
                        "name": "No One"
                    },
                    "Your_Connections": {
                        "data": {
                            "profilePhotoVisibility": "CONNECTIONS"
                        },
                        "name": "Your Connections"
                    },
                    "Your_Network": {
                        "data": {
                            "profilePhotoVisibility": "NETWORK"
                        },
                        "name": "Your Network"
                    },
                    "Everyone": {
                        "data": {
                            "profilePhotoVisibility": "EVERYONE"
                        },
                        "name": "Everyone"
                    }
                },
                "data": {},
                "recommended": "No_One"
            },
            "tags": [
                "exposure",
                "personal data",
                "control"
            ],
            "id": 16
        },
        "see_connections_list": {
            "read": {
                "name": "Who can see the list of your connections?",
                "url": "https://www.linkedin.com/psettings/connections-visibility",
                "availableSettings": {
                    "Only_you": {
                        "name": "Only you",
                        "index": 47
                    },
                    "Your_Connections": {
                        "name": "Your Connections",
                        "index": 48
                    }
                },
                "jquery_selector": {
                    "element": "#setting-connections-visibility .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see the list of your connections?",
                "page": "https://www.linkedin.com/psettings/connections-visibility",
                "url_template": "https://www.linkedin.com/psettings/connections-visibility",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Only_you": {
                        "data": {
                            "isAllowConnectionsBrowse": false
                        },
                        "name": "Only you"
                    },
                    "Your_Connections": {
                        "data": {
                            "isAllowConnectionsBrowse": true
                        },
                        "name": "Your Connections"
                    }
                },
                "data": {},
                "recommended": "Only_you"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 17
        },
        "how_you_rank": {
            "read": {
                "name": "Show \"How You Rank\" to you and other people?",
                "url": "https://www.linkedin.com/psettings/how-you-rank",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 49
                    },
                    "No": {
                        "name": "No",
                        "index": 50
                    }
                },
                "jquery_selector": {
                    "element": "#setting-how-you-rank .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Show \"How You Rank\" to you and other people?",
                "page": "https://www.linkedin.com/psettings/how-you-rank",
                "url_template": "https://www.linkedin.com/psettings/how-you-rank",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "showLeaderBoard": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "showLeaderBoard": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "personal data",
                "control"
            ],
            "id": 18
        },
        "profile_viewers_feature": {
            "read": {
                "name": "Allow \"Viewers of this profile also viewed\" feature on your profile?",
                "url": "https://www.linkedin.com/psettings/browse-map",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 51
                    },
                    "No": {
                        "name": "No",
                        "index": 52
                    }
                },
                "jquery_selector": {
                    "element": "#setting-browse-map .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow \"Viewers of this profile also viewed\" feature on your profile?",
                "page": "https://www.linkedin.com/psettings/browse-map",
                "url_template": "https://www.linkedin.com/psettings/browse-map",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "showBrowseMap": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "showBrowseMap": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 19
        },
        "share_edits": {
            "read": {
                "name": "Let people know when you change your profile, make recommendations, or follow companies?",
                "url": "https://www.linkedin.com/psettings/activity-broadcast",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 53
                    },
                    "No": {
                        "name": "No",
                        "index": 54
                    }
                },
                "jquery_selector": {
                    "element": "#setting-activity-broadcast .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Let people know when you change your profile, make recommendations, or follow companies?",
                "page": "https://www.linkedin.com/psettings/activity-broadcast",
                "url_template": "https://www.linkedin.com/psettings/activity-broadcast",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "isAutoNetworkUpdatesPrefs": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "isAutoNetworkUpdatesPrefs": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 20
        },
        "profile_viewing_options": {
            "read": {
                "name": "What will people see when you have viewed their profile?",
                "url": "https://www.linkedin.com/psettings/profile-visibility",
                "availableSettings": {
                    "Full_profile": {
                        "name": "Full profile",
                        "index": 55
                    },
                    "Characteristics": {
                        "name": "Characteristics",
                        "index": 56
                    },
                    "Private_mode": {
                        "name": "Private mode",
                        "index": 57
                    }
                },
                "jquery_selector": {
                    "element": "#setting-profile-visibility .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "What will people see when you have viewed their profile?",
                "page": "https://www.linkedin.com/psettings/profile-visibility",
                "url_template": "https://www.linkedin.com/psettings/profile-visibility",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Full_profile": {
                        "data": {
                            "discloseAsProfileViewer": "DISCLOSE_FULL"
                        },
                        "name": "Full profile"
                    },
                    "Characteristics": {
                        "data": {
                            "discloseAsProfileViewer": "DISCLOSE_ANONYMOUS"
                        },
                        "name": "Characteristics"
                    },
                    "Private_mode": {
                        "data": {
                            "discloseAsProfileViewer": "HIDE"
                        },
                        "name": "Private mode"
                    }
                },
                "data": {},
                "recommended": "Private_mode"
            },
            "tags": [
                "personal data",
                "control"
            ],
            "id": 21
        },
        "share_you_news": {
            "read": {
                "name": "Let your connections and followers know when you are mentioned in the news?",
                "url": "https://www.linkedin.com/psettings/news-mention-broadcast",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 58
                    },
                    "No": {
                        "name": "No",
                        "index": 59
                    }
                },
                "jquery_selector": {
                    "element": "#setting-news-mention-broadcast .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Let your connections and followers know when you are mentioned in the news?",
                "page": "https://www.linkedin.com/psettings/news-mention-broadcast",
                "url_template": "https://www.linkedin.com/psettings/news-mention-broadcast",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "newsMentionBroadcasts": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "newsMentionBroadcasts": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 22
        },
        "control_followers": {
            "read": {
                "name": "Who can follow you and see your public updates?",
                "url": "https://www.linkedin.com/psettings/allow-follow",
                "availableSettings": {
                    "Your_Connections": {
                        "name": "Your Connections",
                        "index": 60
                    },
                    "Everyone": {
                        "name": "Everyone",
                        "index": 61
                    }
                },
                "jquery_selector": {
                    "element": "#setting-allow-follow .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can follow you and see your public updates?",
                "page": "https://www.linkedin.com/psettings/allow-follow",
                "url_template": "https://www.linkedin.com/psettings/allow-follow",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Your_Connections": {
                        "data": {
                            "isAllowPublicToFollow": false
                        },
                        "name": "Your Connections"
                    },
                    "Everyone": {
                        "data": {
                            "isAllowPublicToFollow": true
                        },
                        "name": "Everyone"
                    }
                },
                "data": {},
                "recommended": "Your_Connections"
            },
            "tags": [
                "contact",
                "control",
                "exposure"
            ],
            "id": 23
        },
        "suggest_you_email": {
            "read": {
                "name": "Who can see you as a suggested connection if they have your email address?",
                "url": "https://www.linkedin.com/psettings/visibility/email",
                "availableSettings": {
                    "Everyone": {
                        "name": "Everyone",
                        "index": 62
                    },
                    "second_degree": {
                        "name": "2nd degree",
                        "index": 63
                    },
                    "Nobody": {
                        "name": "Nobody",
                        "index": 64
                    }
                },
                "jquery_selector": {
                    "element": "#setting-visibility-email .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see you as a suggested connection if they have your email address?",
                "page": "https://www.linkedin.com/psettings/visibility/email",
                "url_template": "https://www.linkedin.com/psettings/visibility/email",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Everyone": {
                        "data": {
                            "visibilitySetting": "EVERYONE"
                        },
                        "name": "Everyone"
                    },
                    "second_degree": {
                        "data": {
                            "visibilitySetting": "SECOND_DEGREE_CONNECTIONS"
                        },
                        "name": "2nd degree"
                    },
                    "Nobody": {
                        "data": {
                            "visibilitySetting": "FIRST_DEGREE_CONNECTIONS"
                        },
                        "name": "Nobody"
                    }
                },
                "data": {
                    "tab": "privacy",
                    "visibilityOptions": "FIRST_DEGREE_CONNECTIONS,SECOND_DEGREE_CONNECTIONS,EVERYONE,$UNKNOWN",
                    "handleType": "EMAIL"
                },
                "recommended": "Nobody"
            },
            "tags": [
                "contact",
                "personal data",
                "discovery"
            ],
            "id": 24
        },
        "suggest_you_phone": {
            "read": {
                "name": "Who can see you as a suggested connection if they have your phone number?",
                "url": "https://www.linkedin.com/psettings/visibility/phone",
                "availableSettings": {
                    "Everyone": {
                        "name": "Everyone",
                        "index": 65
                    },
                    "second_degree": {
                        "name": "2nd degree",
                        "index": 66
                    },
                    "Nobody": {
                        "name": "Nobody",
                        "index": 67
                    }
                },
                "jquery_selector": {
                    "element": "#setting-visibility-phone .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Who can see you as a suggested connection if they have your phone number?",
                "page": "https://www.linkedin.com/psettings/visibility/phone",
                "url_template": "https://www.linkedin.com/psettings/visibility/phone",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Everyone": {
                        "data": {
                            "visibilitySetting": "EVERYONE"
                        },
                        "name": "Everyone"
                    },
                    "second_degree": {
                        "data": {
                            "visibilitySetting": "SECOND_DEGREE_CONNECTIONS"
                        },
                        "name": "2nd degree"
                    },
                    "Nobody": {
                        "data": {
                            "visibilitySetting": "FIRST_DEGREE_CONNECTIONS"
                        },
                        "name": "Nobody"
                    }
                },
                "data": {
                    "tab": "privacy",
                    "visibilityOptions": "FIRST_DEGREE_CONNECTIONS,SECOND_DEGREE_CONNECTIONS,EVERYONE,$UNKNOWN",
                    "handleType": "PHONE"
                },
                "recommended": "Nobody"
            },
            "tags": [
                "contact",
                "personal data",
                "discovery"
            ],
            "id": 25
        },
        "meet_the_team": {
            "read": {
                "name": "Allow Linkedin to show your profile information on your employer's pages?",
                "url": "https://www.linkedin.com/psettings/meet-the-team",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 68
                    },
                    "No": {
                        "name": "No",
                        "index": 69
                    }
                },
                "jquery_selector": {
                    "element": "#setting-meet-the-team .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow Linkedin to show your profile information on your employer's pages?",
                "page": "https://www.linkedin.com/psettings/meet-the-team",
                "url_template": "https://www.linkedin.com/psettings/meet-the-team",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "isAllowShownInMeetTheTeam": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "isAllowShownInMeetTheTeam": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "control",
                "exposure",
                "personal data"
            ],
            "id": 26
        },
        "share_data_with_third_party_applications": {
            "read": {
                "name": "Allow LinkedIn to share your data with third party applications?",
                "url": "https://www.linkedin.com/psettings/data-sharing",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 70
                    },
                    "No": {
                        "name": "No",
                        "index": 71
                    }
                },
                "jquery_selector": {
                    "element": "#setting-data-sharing .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow LinkedIn to share your data with third party applications?",
                "page": "https://www.linkedin.com/psettings/data-sharing",
                "url_template": "https://www.linkedin.com/psettings/data-sharing",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "blockThirdPartyDataSharing": false
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "blockThirdPartyDataSharing": true
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "applications",
                "personal data",
                "profiling"
            ],
            "id": 27
        },
        "share_data_with_third_party_platforms": {
            "read": {
                "name": "Allow LinkedIn to share your data with third party platforms?",
                "url": "https://www.linkedin.com/psettings/data-sharing",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 72
                    },
                    "No": {
                        "name": "No",
                        "index": 73
                    }
                },
                "jquery_selector": {
                    "element": "input[id='option-block-platforms']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Allow LinkedIn to share your data with third party platforms?",
                "page": "https://www.linkedin.com/psettings/data-sharing",
                "url_template": "https://www.linkedin.com/psettings/data-sharing",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "blockThirdPartyDataSharing": false,
                            "blockThirdPartyContactDataSharing": false
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "blockThirdPartyDataSharing": true,
                            "blockThirdPartyContactDataSharing": true
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "personal data",
                "profiling"
            ],
            "id": 28
        },
        "cookie_personalised_ads": {
            "read": {
                "name": "Allow LinkedIn to use cookies and trackers on third party sites to target you with ads and personalized services?",
                "url": "https://www.linkedin.com/psettings/enhanced-advertising",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 74
                    },
                    "No": {
                        "name": "No",
                        "index": 75
                    }
                },
                "jquery_selector": {
                    "element": "#setting-enhanced-advertising .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow LinkedIn to use cookies and trackers on third party sites to target you with ads and personalized services?",
                "page": "https://www.linkedin.com/psettings/enhanced-advertising",
                "url_template": "https://www.linkedin.com/psettings/enhanced-advertising",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "isAllowLANTargeting": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "isAllowLANTargeting": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "advertising",
                "profiling",
                "personal data",
                "control"
            ],
            "id": 29
        },
        "control_messages_invitations": {
            "read": {
                "name": "Receive requests to join your network?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 76
                    },
                    "Off": {
                        "name": "Off",
                        "index": 77
                    }
                },
                "jquery_selector": {
                    "element": "input[id='invitationsGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive requests to join your network?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "invitationPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "groupInvitationPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "inviteAcceptNotification",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "invitationsGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "invitationPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "groupInvitationPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "inviteAcceptNotification",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "invitationsGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "Off"
            },
            "tags": [
                "contact",
                "control"
            ],
            "id": 30
        },
        "control_messages_messages": {
            "read": {
                "name": "Receive messages from other LinkedIn members?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 78
                    },
                    "Off": {
                        "name": "Off",
                        "index": 79
                    }
                },
                "jquery_selector": {
                    "element": "input[id='invitationsGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive messages from other LinkedIn members?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "repliesPreference",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "inmailNotification",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "profileForwardsPrefs",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "messagesGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "repliesPreference",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "inmailNotification",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "profileForwardsPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "messagesGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "Off"
            },
            "tags": [
                "contact",
                "control"
            ],
            "id": 31
        },
        "control_messages_notifications": {
            "read": {
                "name": "Receive news about activity related to your profile and what you share?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 80
                    },
                    "Off": {
                        "name": "Off",
                        "index": 81
                    }
                },
                "jquery_selector": {
                    "element": "input[id='invitationsGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive news about activity related to your profile and what you share?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "endorsementPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "professionalIdentityDigest",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "mentionsPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "statusDiscussionNotificationPref",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "notificationDigestPrefs",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "starUpdate",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "notificationsGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "endorsementPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "professionalIdentityDigest",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "mentionsPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "statusDiscussionNotificationPref",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "notificationDigestPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "starUpdate",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "notificationsGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control"
            ],
            "id": 32
        },
        "control_messages_network_updates": {
            "read": {
                "name": "Receive updates about your connections?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 82
                    },
                    "Off": {
                        "name": "Off",
                        "index": 83
                    }
                },
                "jquery_selector": {
                    "element": "input[id='updatesFromNetworkGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive updates about your connections?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "networkUpdatesCommPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "peopleInTheNewsDigest",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "connectionSuggestionPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "contactJoinNotificationPrefs",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "updatesFromNetworkGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "topLevelNodeId": "root",
                            "changedNodes": [
                                {
                                    "nodeId": "networkUpdatesCommPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "peopleInTheNewsDigest",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "connectionSuggestionPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "contactJoinNotificationPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "updatesFromNetworkGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control"
            ],
            "id": 33
        },
        "control_messages_jobs_and_opportunities": {
            "read": {
                "name": "Receive updates about Jobs and opportunities?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 84
                    },
                    "Off": {
                        "name": "Off",
                        "index": 85
                    }
                },
                "jquery_selector": {
                    "element": "input[id='jobSeekerGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive updates about Jobs and opportunities?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "jymbiiEmailFrequency",
                                    "newValue": "PERIODIC"
                                },
                                {
                                    "nodeId": "referralCenterEmailsPref",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "jobBroadcastsCommPrefs",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "jobApplicationConfirmationEmail",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "jobSeekerGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "jymbiiEmailFrequency",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "referralCenterEmailsPref",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "jobBroadcastsCommPrefs",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "jobApplicationConfirmationEmail",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "jobSeekerGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {
                    "topLevelNodeId": "root"
                },
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control"
            ],
            "id": 34
        },
        "control_messages_news": {
            "read": {
                "name": "Receive news and articles relevant to you?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 86
                    },
                    "Off": {
                        "name": "Off",
                        "index": 87
                    }
                },
                "jquery_selector": {
                    "element": "input[id='newsGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive news and articles relevant to you?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "topArticlesNewsDigest",
                                    "newValue": "AUTOMATIC"
                                },
                                {
                                    "nodeId": "editorialAuthorOutreachEmail",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "newsGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "topArticlesNewsDigest",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "editorialAuthorOutreachEmail",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "newsGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {
                    "topLevelNodeId": "root"
                },
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control"
            ],
            "id": 35
        },
        "control_messages_from_linkedIn": {
            "read": {
                "name": "Receive occasional emails with tips and offers to help you get the most out of LinkedIn?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 88
                    },
                    "Off": {
                        "name": "Off",
                        "index": 89
                    }
                },
                "jquery_selector": {
                    "element": "input[id='messagesFromLinkedinGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive occasional emails with tips and offers to help you get the most out of LinkedIn?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "marketingEmailPref",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "messagesFromLinkedinGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "marketingEmailPref",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "messagesFromLinkedinGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {
                    "topLevelNodeId": "root"
                },
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control",
                "contact"
            ],
            "id": 36
        },
        "control_messages_from_linkedIn_learning": {
            "read": {
                "name": "Receive recommendations to help you get the most out of LinkedIn Learning?",
                "url": "https://www.linkedin.com/psettings/email-controls",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 90
                    },
                    "Off": {
                        "name": "Off",
                        "index": 91
                    }
                },
                "jquery_selector": {
                    "element": "input[id='messagesFromLearningGroup']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Receive recommendations to help you get the most out of LinkedIn Learning?",
                "page": "https://www.linkedin.com/psettings/email-controls",
                "url_template": "https://www.linkedin.com/psettings/email-controls/updateSettings?csrfToken={CSRF_TOKEN}",
                "type": "application/json",
                "availableSettings": {
                    "On": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "learningDigestEmail",
                                    "newValue": true
                                },
                                {
                                    "nodeId": "messagesFromLearningGroup",
                                    "newValue": true
                                }
                            ]
                        },
                        "name": "On"
                    },
                    "Off": {
                        "params": {
                            "csrfToken": {
                                "placeholder": "CSRF_TOKEN",
                                "type": "dynamic"
                            }
                        },
                        "data": {
                            "changedNodes": [
                                {
                                    "nodeId": "learningDigestEmail",
                                    "newValue": false
                                },
                                {
                                    "nodeId": "messagesFromLearningGroup",
                                    "newValue": false
                                }
                            ]
                        },
                        "name": "Off"
                    }
                },
                "data": {
                    "topLevelNodeId": "root"
                },
                "recommended": "Off"
            },
            "tags": [
                "profiling",
                "control",
                "contact"
            ],
            "id": 37
        },
        "who_can_invite_you": {
            "read": {
                "name": "Select who can send you invitations",
                "url": "https://www.linkedin.com/psettings/invite-receive",
                "availableSettings": {
                    "Everyone": {
                        "name": "Everyone",
                        "index": 92
                    },
                    "Email_and_Imported_contacts": {
                        "name": "Email and Imported contacts",
                        "index": 93
                    },
                    "Imported_contacts": {
                        "name": "Imported contacts",
                        "index": 94
                    }
                },
                "jquery_selector": {
                    "element": "#setting-invite-receive .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Select who can send you invitations",
                "page": "https://www.linkedin.com/psettings/invite-receive",
                "url_template": "https://www.linkedin.com/psettings/invite-receive",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Everyone": {
                        "data": {
                            "inviteReceiveParam": "BLOCK_NO_INVITATIONS"
                        },
                        "name": "Everyone"
                    },
                    "Email_and_Imported_contacts": {
                        "data": {
                            "inviteReceiveParam": "BLOCK_RECONNECT_ACCEPT_STD"
                        },
                        "name": "Email and Imported contacts"
                    },
                    "Imported_contacts": {
                        "data": {
                            "inviteReceiveParam": "BLOCK_ALL"
                        },
                        "name": "Imported contacts"
                    }
                },
                "data": {},
                "recommended": "Imported_contacts"
            },
            "tags": [
                "contact",
                "control"
            ],
            "id": 38
        },
        "enable_group_invitations": {
            "read": {
                "name": "Receive invitations to join groups? ",
                "url": "https://www.linkedin.com/psettings/group-invitations",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 95
                    },
                    "No": {
                        "name": "No",
                        "index": 96
                    }
                },
                "jquery_selector": {
                    "element": "#setting-group-invitations .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Receive invitations to join groups? ",
                "page": "https://www.linkedin.com/psettings/group-invitations",
                "url_template": "https://www.linkedin.com/psettings/group-invitations",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "receiveGroupInvitations": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "receiveGroupInvitations": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "contact",
                "control"
            ],
            "id": 39
        },
        "enable_group_notifications": {
            "read": {
                "name": "Allow LinkedIn to notify your network when you join a group?",
                "url": "https://www.linkedin.com/psettings/group-join-notifications",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 97
                    },
                    "No": {
                        "name": "No",
                        "index": 98
                    }
                },
                "jquery_selector": {
                    "element": "#setting-group-join-notifications .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Allow LinkedIn to notify your network when you join a group?",
                "page": "https://www.linkedin.com/psettings/group-join-notifications",
                "url_template": "https://www.linkedin.com/psettings/group-join-notifications",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "sendGroupJoinNotifications": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "sendGroupJoinNotifications": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "exposure",
                "control"
            ],
            "id": 40
        },
        "enable_research_invitations": {
            "read": {
                "name": "Turn on/off invitations to participate in research",
                "url": "https://www.linkedin.com/psettings/research-invitations",
                "availableSettings": {
                    "On": {
                        "name": "On",
                        "index": 99
                    },
                    "Off": {
                        "name": "Off",
                        "index": 100
                    }
                },
                "jquery_selector": {
                    "element": "#setting-research-invitations .state",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Turn on/off invitations to participate in research",
                "page": "https://www.linkedin.com/psettings/research-invitations",
                "url_template": "https://www.linkedin.com/psettings/research-invitations",
                "type": "multipart/form-data",
                "availableSettings": {
                    "On": {
                        "data": {
                            "researchInvitation": true
                        },
                        "name": "On"
                    },
                    "Off": {
                        "data": {
                            "researchInvitation": false
                        },
                        "name": "Off"
                    }
                },
                "data": {},
                "recommended": "Off"
            },
            "tags": [
                "contact"
            ],
            "id": 41
        },
        "allow_partner_inmail": {
            "read": {
                "name": "Allow InMail from LinkedIn partners?",
                "url": "https://www.linkedin.com/psettings/partner-inmail",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 101
                    },
                    "No": {
                        "name": "No",
                        "index": 102
                    }
                },
                "jquery_selector": {
                    "element": "input[id='option-partner-inmail-marketing']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Allow InMail from LinkedIn partners?",
                "page": "https://www.linkedin.com/psettings/partner-inmail",
                "url_template": "https://www.linkedin.com/psettings/partner-inmail",
                "type": "multipart/form-data",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "openToMarketingPartnerMessages": true,
                            "hasMarketingSuccess": true,
                            "openToJobOpportunitiesPartnerMessages": true,
                            "hasHiringSuccess": false
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "openToMarketingPartnerMessages": false,
                            "hasMarketingSuccess": false,
                            "openToJobOpportunitiesPartnerMessages": false,
                            "hasHiringSuccess": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "contact"
            ],
            "id": 42
        },
        "allow_hiring_campaign_partner_inmail": {
            "read": {
                "name": "Allow hiring campaigns from LinkedIn partners?",
                "url": "https://www.linkedin.com/psettings/partner-inmail",
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 103
                    },
                    "No": {
                        "name": "No",
                        "index": 104
                    }
                },
                "jquery_selector": {
                    "element": "input[id='option-partner-inmail-marketing']",
                    "valueType": "checkbox"
                }
            },
            "write": {
                "name": "Allow hiring campaigns from LinkedIn partners?",
                "page": "https://www.linkedin.com/psettings/partner-inmail",
                "url_template": "https://www.linkedin.com/psettings/partner-inmail",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "openToJobOpportunitiesPartnerMessages": true,
                            "hasHiringSuccess": true,
                            "openToMarketingPartnerMessages": true,
                            "hasMarketingSuccess": false
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "openToJobOpportunitiesPartnerMessages": false,
                            "hasHiringSuccess": false,
                            "openToMarketingPartnerMessages": false,
                            "hasMarketingSuccess": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "contact",
                "advertising"
            ],
            "id": 43
        }
    },
    "twitter": {
        "protect_tweets": {
            "read": {
                "name": "Protect my Tweets?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='user_protected']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 105
                    },
                    "No": {
                        "name": "No",
                        "index": 106
                    }
                }
            },
            "write": {
                "name": "Protect my Tweets?",
                "page": "https://mobile.twitter.com/settings/safety",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "protected": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "protected": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "discovery",
                "control"
            ],
            "id": 44
        },
        "tweet_location": {
            "read": {
                "name": "Add a location to my tweets?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[name='user[geo_enabled]']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "Yes": {
                        "name": "Yes",
                        "index": 107
                    },
                    "No": {
                        "name": "No",
                        "index": 108
                    }
                }
            },
            "write": {
                "name": "Add a location to my tweets?",
                "page": "https://mobile.twitter.com/settings/location",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "Yes": {
                        "data": {
                            "geo_enabled": true
                        },
                        "name": "Yes"
                    },
                    "No": {
                        "data": {
                            "geo_enabled": false
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "No"
            },
            "tags": [
                "discovery",
                "exposure"
            ],
            "id": 45
        },
        "allow_photo_tag": {
            "read": {
                "name": "Allow anyone to tag you in photos?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[name='user[allow_media_tagging]']",
                    "valueType": "radio"
                },
                "availableSettings": {
                    "all": {
                        "name": "Allow anyone to tag me in photos",
                        "index": 109
                    },
                    "following": {
                        "name": "Only allow people I follow to tag me in photos",
                        "index": 110
                    },
                    "none": {
                        "name": "Do not allow anyone to tag me in photos",
                        "index": 111
                    }
                }
            },
            "write": {
                "name": "Allow anyone to tag you in photos?",
                "page": "https://mobile.twitter.com/settings/tagging",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "all": {
                        "data": {
                            "allow_media_tagging": "all"
                        },
                        "name": "All"
                    },
                    "following": {
                        "data": {
                            "allow_media_tagging": "following"
                        },
                        "name": "Following"
                    },
                    "none": {
                        "data": {
                            "allow_media_tagging": "none"
                        },
                        "name": "None"
                    }
                },
                "data": {},
                "recommended": "none"
            },
            "tags": [
                "discovery",
                "exposure"
            ],
            "id": 46
        },
        "allow_email_search": {
            "read": {
                "name": "Allow others find you by your email address?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='user_discoverable_by_email']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 112
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 113
                    }
                }
            },
            "write": {
                "name": "Allow others find you by your email address?",
                "page": "https://mobile.twitter.com/settings/contacts",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "discoverable_by_email": true
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "discoverable_by_email": false
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "contact",
                "exposure"
            ],
            "id": 47
        },
        "allow_phone_search": {
            "read": {
                "name": "Allow others find you by your mobile phone number?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='user_mobile_discoverable']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 114
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 115
                    }
                }
            },
            "write": {
                "name": "Allow others find you by your mobile phone number?",
                "page": "https://mobile.twitter.com/settings/contacts",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "discoverable_by_mobile_phone": true
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "discoverable_by_mobile_phone": false
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "contact",
                "discovery",
                "control"
            ],
            "id": 48
        },
        "allow_promoted_content": {
            "read": {
                "name": "Allow Twitter to display ads about things you've already shown interest in (aka \"promoted content\")?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='allow_ads_personalization']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 116
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 117
                    }
                }
            },
            "write": {
                "name": "Allow Twitter to display ads about things you've already shown interest in (aka \"promoted content\")?",
                "page": "https://mobile.twitter.com/settings/safety",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "allow_ads_personalization": true
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "allow_ads_personalization": false
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "advertising",
                "profiling",
                "personal data",
                "control"
            ],
            "id": 49
        },
        "allow_direct_message": {
            "read": {
                "name": "Allow any Twitter user to send you a direct message even if you do not follow them?",
                "url": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='allow_dms_from_anyone']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 118
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 119
                    }
                }
            },
            "write": {
                "name": "Allow any Twitter user to send you a direct message even if you do not follow them?",
                "page": "https://mobile.twitter.com/settings/safety",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "allow_dms_from": "all"
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "allow_dms_from": "following"
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "profiling",
                "personal data",
                "control"
            ],
            "id": 50
        },
        "send_read_receipts": {
            "read": {
                "name": "Allow that when someone sends you a message, people in the conversation will know when you have seen it?",
                "page": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[id='allow_dm_receipts']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 120
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 121
                    }
                }
            },
            "write": {
                "name": "Allow that when someone sends you a message, people in the conversation will know when you have seen it?",
                "page": "https://mobile.twitter.com/settings/safety",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "dm_receipt_setting": "all_enabled"
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "dm_receipt_setting": "all_disabled"
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "exposure",
                "profiling",
                "personal data",
                "control"
            ],
            "id": 51
        },
        "display_sensitive_content": {
            "read": {
                "name": "Allow to display media that may contain sensitive content?",
                "page": "https://twitter.com/settings/safety",
                "jquery_selector": {
                    "element": "input[name='user[nsfw_view]']",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "allow": {
                        "name": "Allow",
                        "index": 122
                    },
                    "disallow": {
                        "name": "Disallow",
                        "index": 123
                    }
                }
            },
            "write": {
                "name": "Allow to display media that may contain sensitive content?",
                "page": "https://mobile.twitter.com/settings/safety",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "availableSettings": {
                    "allow": {
                        "data": {
                            "display_sensitive_media": true
                        },
                        "name": "Allow"
                    },
                    "disallow": {
                        "data": {
                            "display_sensitive_media": false
                        },
                        "name": "Disallow"
                    }
                },
                "recommended": "disallow"
            },
            "tags": [
                "exposure",
                "profiling",
                "control"
            ],
            "id": 52
        },
        "personalize_ads": {
            "read": {
                "name": "Do you want to see interest-based ads?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(0)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 124
                    },
                    "no": {
                        "name": "No",
                        "index": 125
                    }
                }
            },
            "write": {
                "name": "Do you want to see interest-based ads?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "recommended": "no",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "allow_ads_personalization": true
                        }
                    },
                    "no": {
                        "data": {
                            "allow_ads_personalization": false
                        }
                    }
                }
            },
            "id": 53
        },
        "personalize_ads_apps": {
            "read": {
                "name": "Do you want to see ads based on your apps?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(1)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 126
                    },
                    "no": {
                        "name": "No",
                        "index": 127
                    }
                }
            },
            "write": {
                "name": "Do you want to see ads based on your apps?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/personalization/p13n_preferences.json",
                "recommended": "no",
                "type": "application/json",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "preferences": {
                                "app_graph_preferences": {
                                    "use_app_graph_for_personalization": true
                                }
                            }
                        }
                    },
                    "no": {
                        "data": {
                            "preferences": {
                                "app_graph_preferences": {
                                    "use_app_graph_for_personalization": false
                                }
                            }
                        }
                    }
                }
            },
            "id": 54
        },
        "personalize_ads_devices": {
            "read": {
                "name": "Do you want to see ads based on your devices?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(2)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 128
                    },
                    "no": {
                        "name": "No",
                        "index": 129
                    }
                }
            },
            "write": {
                "name": "Do you want to see ads based on your devices?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "recommended": "no",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "allow_logged_out_device_personalization": true
                        }
                    },
                    "no": {
                        "data": {
                            "allow_logged_out_device_personalization": false
                        }
                    }
                }
            },
            "id": 55
        },
        "personalize_ads_location": {
            "read": {
                "name": "Do you want to see ads based on places you've been?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(3)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 130
                    },
                    "no": {
                        "name": "No",
                        "index": 131
                    }
                }
            },
            "write": {
                "name": "Do you want to see ads based on places you've been?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "recommended": "no",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "allow_location_history_personalization": true
                        }
                    },
                    "no": {
                        "data": {
                            "allow_location_history_personalization": false
                        }
                    }
                }
            },
            "id": 56
        },
        "track_across_web": {
            "read": {
                "name": "Do you want to be tracked by twitter content around the web?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(4)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 132
                    },
                    "no": {
                        "name": "No",
                        "index": 133
                    }
                }
            },
            "write": {
                "name": "Do you want to be tracked by twitter content around the web?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "recommended": "no",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "use_cookie_personalization": true
                        }
                    },
                    "no": {
                        "data": {
                            "use_cookie_personalization": false
                        }
                    }
                }
            },
            "id": 57
        },
        "share_data_partnership": {
            "read": {
                "name": "Share certain private data (which will never include your name, email, or phone number) through select partnerships?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "jquery_selector": {
                    "element": "input[type='checkbox']:nth-child(5)",
                    "valueType": "checkbox"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 134
                    },
                    "no": {
                        "name": "No",
                        "index": 135
                    }
                }
            },
            "write": {
                "name": "Share certain private data (which will never include your name, email, or phone number) through select partnerships?",
                "page": "https://mobile.twitter.com/settings/account/personalization",
                "url_template": "https://api.twitter.com/1.1/account/settings.json",
                "recommended": "no",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "allow_sharing_data_for_third_party_personalization": true
                        }
                    },
                    "no": {
                        "data": {
                            "allow_sharing_data_for_third_party_personalization": false
                        }
                    }
                }
            },
            "id": 58
        }
    },
    "google": {
        "declare_gender": {
            "read": {
                "name": "Show gender?",
                "url": "https://myaccount.google.com/gender",
                "availableSettings": {
                    "male": {
                        "name": "Male",
                        "index": 136
                    },
                    "female": {
                        "name": "Female",
                        "index": 137
                    },
                    "rather_not_say": {
                        "name": "Rather not say",
                        "index": 138
                    }
                },
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                }
            },
            "write": {
                "name": "Show gender?",
                "page": "https://myaccount.google.com/gender",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=107941241&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "male": {
                        "params": {
                            "reqid": {
                                "placeholder": "REQID",
                                "value": 1000000
                            }
                        },
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",107941241,[{\"107941241\":[[2]]}]]]]"
                        },
                        "name": "Male"
                    },
                    "female": {
                        "params": {
                            "reqid": {
                                "placeholder": "REQID",
                                "value": 2000000
                            }
                        },
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",107941241,[{\"107941241\":[[3]]}]]]]"
                        },
                        "name": "Female"
                    },
                    "rather_not_say": {
                        "params": {
                            "reqid": {
                                "placeholder": "REQID",
                                "value": 3000000
                            }
                        },
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",107941241,[{\"107941241\":[[4]]}]]]]"
                        },
                        "name": "Rather not say"
                    }
                },
                "data": {},
                "recommended": "rather_not_say"
            },
            "tags": [
                "exposure"
            ],
            "id": 59
        },
        "group_similar_face": {
            "read": {
                "name": "Auto group photos by matching faces to better search, manage, and share?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 139
                    },
                    "no": {
                        "name": "No",
                        "index": 140
                    }
                }
            },
            "write": {
                "name": "Auto group photos by matching faces to better search, manage, and share?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",18,true]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",18,false]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "no"
            },
            "tags": [
                "exposure"
            ],
            "id": 60
        },
        "remove_geo_location": {
            "read": {
                "name": "Remove geo location in items shared by link?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 141
                    },
                    "no": {
                        "name": "No",
                        "index": 142
                    }
                }
            },
            "write": {
                "name": "Remove geo location in items shared by link?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",19,false]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",19,true]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "yes"
            },
            "tags": [
                "exposure"
            ],
            "id": 61
        },
        "liked_videos_private": {
            "read": {
                "name": "Keep private all my liked videos?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 143
                    },
                    "no": {
                        "name": "No",
                        "index": 144
                    }
                }
            },
            "write": {
                "name": "Keep private all my liked videos?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",20,false]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",20,true]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "yes"
            },
            "tags": [
                "exposure"
            ],
            "id": 62
        },
        "saved_playlist_private": {
            "read": {
                "name": "Keep private all my saved playlists?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 145
                    },
                    "no": {
                        "name": "No",
                        "index": 146
                    }
                }
            },
            "write": {
                "name": "Keep private all my saved playlists?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",21,false]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",21,true]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "yes"
            },
            "tags": [
                "exposure"
            ],
            "id": 63
        },
        "keep_subscriptions_private": {
            "read": {
                "name": "Keep private all my subscriptions?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 147
                    },
                    "no": {
                        "name": "No",
                        "index": 148
                    }
                }
            },
            "write": {
                "name": "Keep private all my subscriptions?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",6,false]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",6,true]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "yes"
            },
            "tags": [
                "exposure"
            ],
            "id": 64
        },
        "post_feed_public_playlist": {
            "read": {
                "name": "Post to feed when I add a video to a public playlist?",
                "page": "https://myaccount.google.com/privacycheckup",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 149
                    },
                    "no": {
                        "name": "No",
                        "index": 150
                    }
                }
            },
            "write": {
                "name": "Post to feed when I add a video to a public playlist?",
                "page": "https://myaccount.google.com/privacycheckup",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=123193202&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",10,true]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",123193202,[{\"123193202\":[\"ac.pg.pstrq\",10,false]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "yes"
            },
            "tags": [
                "exposure"
            ],
            "id": 65
        },
        "shared_endorsements_ads": {
            "read": {
                "name": "Based upon my activity, Google may show my profile name, profile photo, and activity in shared endorsements in ads?",
                "page": "https://myaccount.google.com/shared-endorsements",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 151
                    },
                    "no": {
                        "name": "No",
                        "index": 152
                    }
                }
            },
            "write": {
                "name": "Based upon my activity, Google may show my profile name, profile photo, and activity in shared endorsements in ads?",
                "page": "https://myaccount.google.com/shared-endorsements",
                "url_template": "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=130628706&f.sid={SID}&hl=en&_reqid={REQID}&rt=c",
                "availableSettings": {
                    "yes": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",130628706,[{\"130628706\":[true,\"RnVjayB5b3UgR09PR0xFIQ==\"]}]]]]"
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "data": {
                            "f.req": "[\"af.maf\",[[\"af.add\",130628706,[{\"130628706\":[false,\"SSB3YXMga2lkZGluZyE=\"]}]]]]"
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "no"
            },
            "tags": [
                "exposure"
            ],
            "id": 66
        },
        "search_private_results": {
            "read": {
                "name": "Use private results?",
                "page": "https://www.google.com/preferences",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes",
                        "index": 153
                    },
                    "no": {
                        "name": "No",
                        "index": 154
                    }
                }
            },
            "write": {
                "name": "Use private results?",
                "page": "https://www.google.com/preferences",
                "url_template": "https://www.google.com/setprefs?sig={SIG}&submit2=Save+Preferences&hl=&lang=&lr=&safeui=&num=&pson={PSON}&tts=&newwindow=&gl=&region=&q=&prev=",
                "method_type": "GET",
                "availableSettings": {
                    "yes": {
                        "params": {
                            "pson": {
                                "placeholder": "PSON",
                                "value": 1
                            }
                        },
                        "name": "Yes"
                    },
                    "no": {
                        "params": {
                            "pson": {
                                "placeholder": "PSON",
                                "value": 0
                            }
                        },
                        "name": "No"
                    }
                },
                "data": {},
                "recommended": "no"
            },
            "id": 67
        },
        "text_to_speach": {
            "read": {
                "name": "When you search by voice, Google should speak the answers aloud?",
                "page": "https://www.google.com/preferences",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "yes": {
                        "name": "Yes, speak answers for voice search",
                        "index": 155
                    },
                    "no": {
                        "name": "No, just show text",
                        "index": 156
                    }
                }
            },
            "write": {
                "name": "Use private results?",
                "page": "https://www.google.com/preferences",
                "url_template": "https://www.google.com/setprefs?sig={SIG}&submit2=Save+Preferences&hl=&lang=&lr=&safeui=&num=&pson=&tts={TTS}&newwindow=&gl=&region=&q=&prev=",
                "method_type": "GET",
                "availableSettings": {
                    "yes": {
                        "params": {
                            "tts": {
                                "placeholder": "TTS",
                                "value": 1
                            }
                        },
                        "name": "Yes, speak answers for voice search"
                    },
                    "no": {
                        "params": {
                            "tts": {
                                "placeholder": "TTS",
                                "value": 0
                            }
                        },
                        "name": "No, just show text"
                    }
                },
                "data": {},
                "recommended": "no"
            },
            "id": 68
        },
        "web_app_activity": {
            "read": {
                "name": "Web & app activity",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "index": 157
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "index": 158
                    }
                }
            },
            "write": {
                "name": "Web and app activity",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 69
        },
        "location_history": {
            "read": {
                "name": "Location History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "index": 159
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "index": 160
                    }
                }
            },
            "write": {
                "name": "Location History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 70
        },
        "device_information": {
            "read": {
                "name": "Device Information",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        },
                        "index": 161
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        },
                        "index": 162
                    }
                }
            },
            "write": {
                "name": "Device Information",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 71
        },
        "voice_audio_activity": {
            "read": {
                "name": "Voice & Audio Activity",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "index": 163
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "index": 164
                    }
                }
            },
            "write": {
                "name": "Voice & Audio Activity",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 72
        },
        "youtube_search_history": {
            "read": {
                "name": "Youtube Search History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "index": 165
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "index": 166
                    }
                }
            },
            "write": {
                "name": "Youtube Search History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 73
        },
        "youtube_watch_history": {
            "read": {
                "name": "Youtube Watch History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "index": 167
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "index": 168
                    }
                }
            },
            "write": {
                "name": "Youtube Watch History",
                "page": "https://myaccount.google.com/activitycontrols",
                "method_type": "user-action",
                "jquery_selector": {
                    "element": ".N2RpBe:parent + .XZs2ib .N2RpBe",
                    "valueType": "inner"
                },
                "availableSettings": {
                    "on": {
                        "name": "On",
                        "cssClasses": "LsSwGf PciPcd N2RpBe",
                        "data": {
                            "setting": "on"
                        }
                    },
                    "off": {
                        "name": "Off",
                        "cssClasses": "LsSwGf PciPcd i9xfbb",
                        "data": {
                            "setting": "off"
                        }
                    }
                },
                "recommended": "off"
            },
            "id": 74
        }
    }
}