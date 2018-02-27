(function()
{
 
 

var SN_CONSTANTS ={
    FACEBOOK:{
        public:300645083384735,
        everyone:300645083384735,
        friends_of_friends:275425949243301,
        friends_except_acquaintances:284920934947802,
        only_me:286958161406148,
        friends:291667064279714

    }
};


var ospSettingsConfig = {

    "facebook": {
       who_can_see_future_posts: {
            read:{
                name: "Who can see your future posts?",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    public:{
                        name:"Public"
                    },
                    friends:{
                        name:"Friends"
                    },
                    only_me:{
                        name:"Only Me"
                    }
                },
                jquery_selector:{
                element:".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
           write: {
               name: "Who can see your future posts?",
               page: "https://www.facebook.com/settings?tab=privacy&section=composer&view",
               url_template: "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=22&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
               availableSettings: {
                   public: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.public
                           }
                       },
                       name: "Public"
                   },
                   friends: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.friends
                           }
                       },
                       name: "Friends"
                   },
                   only_me: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.only_me
                           }
                       },
                       name: "Only Me"
                   }
               },

               data: {},
               recommended: "friends"
           }
        },
        /*activity_log:{
            read:{
                name: "Keep/delete your activity log",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Keep", "Delete"],

                jquery_selector:{

                }
            },
            write:{
                recommended:"Delete"
            }
        },*/
        /*friends_of_friends:{
            read:{
                name: "Choose if only Friends or also Friends of Friends can see your Facebook data",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Friends", "Friends of Friends"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Friends"
            }
        },*/
        /*limit_old_posts:{
            read:{
                name: "Limit (or not) viewing content on your timeline you have shared with Friends of Friends or Public, to Friends only.",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Public", "Friends of Friends", "Friends"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Friends"
            }
        },*/
        who_can_contact:{
            read:{
                name: "Choose who can contact you/send you friend requests",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        name:"Everyone"
                    },
                    friends_of_friends:{
                        name:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element :".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can contact me?",
                page:"https://www.facebook.com/settings?tab=privacy&section=canfriend&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787540733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787540733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    }
                },
                data:{},
                recommended:"friends_of_friends"
            }
        },
        lookup_email:{
            read:{
                name: "Choose who can look you up using your email address",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        name:"Everyone"
                    },
                    friends:{
                        name:"Friends"
                    },
                    friends_of_friends:{
                        name:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(0) ._nlm",
                    valueType:"inner"
                }
            },
            write:{
                name:"Who can look me up by email address",
                page:"https://www.facebook.com/settings?tab=privacy&section=findemail&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    }
                },
                data:{},
                recommended:"friends"
            }
        },
        lookup_phone:{
            read:{
                name: "Choose  who can look you up using the phone number you provided",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        name:"Everyone"
                    },
                    friends:{
                        name:"Friends"
                    },
                    friends_of_friends:{
                        name:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can look me up by phone",
                page:"https://www.facebook.com/settings?tab=privacy&section=findphone&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    }
                },
                data:{},
                recommended:"friends"
            }
        },
        search_engine:{
            read:{
                name: "Allow/disallow engines outside Facebook to link to your profile",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings: {
                    yes: {
                        name: "Yes"
                    },
                    no: {
                        name: "No"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(2) .fbSettingsListItem:eq(2) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can look me up by search engines",
                page:"https://www.facebook.com/settings?tab=privacy&section=search&view",
                url_template:"https://www.facebook.com/ajax/settings_page/search_filters.php?dpr=1",
                availableSettings: {
                    yes:{
                        data:{
                            "el":"search_filter_public",
                            "public":1
                        },
                        name:"Yes"
                    },
                    no:{
                        data:{
                            "el":"search_filter_public",
                            "public":0
                        },
                        name:"No"
                    }

                },
                data:{},
                recommended:"no"
            }
        },
        limit_timeline:{
            read:{
                name: "Limit who can add things to your timeline",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings: {
                    only_me: {
                        name: "Only Me"
                    },
                    friends: {
                        name: "Friends"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can add things to my timeline?",
                page:"https://www.facebook.com/settings?tab=timeline&section=posting&view",
                url_template:"https://www.facebook.com/ajax/settings/timeline/posting.php?dpr=1",
                availableSettings:{
                    only_me:{
                        data:{
                            audience:10
                        },
                        name:"Only Me"
                    },

                    friends:{
                        data:{
                            audience:40
                        },
                        name:"Friends"
                    }
                },
                data:{},
                recommended:"only_me"
            }
        },
        control_timeline:{
            read:{
                name: "Review tags people add to your own posts before the tags appear on Facebook",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings: {
                    enabled: {
                        name: "On"
                    },
                    disabled: {
                        name: "Off"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(0) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Review tags people add to your own posts before the tags appear on Facebook",
                page:"https://www.facebook.com/settings?tab=timeline&section=review&view",
                url_template:"https://www.facebook.com/ajax/settings/timeline/review.php?dpr=1",
                availableSettings: {
                    enabled: {
                        data:{
                            tag_approval_enabled:1
                        },
                        name:"On"
                    },
                    disabled: {
                        data:{
                            tag_approval_enabled:0
                        },
                        name:"Off"
                    }
                },
                data:{},
                recommended:"enabled"
            }
        },

        timeline_posts_tags:{
          read:{
              name: "Who can see posts you've been tagged in on your timeline?",
              url: "https://www.facebook.com/settings?tab=timeline",
              availableSettings: {
                  everyone: {
                      name: "Everyone"
                  },
                  friends_of_friends:{
                      name:"Friends of Friends"
                  },
                  friends:{
                      name:"Friends"
                  },
                  friends_except_acquaintances:{
                      name:"Friends except Acquaintances"
                  },
                  only_me:{
                      name:"Only Me"
                  }

              },
              jquery_selector:{
                  element:".fbSettingsList:eq(1) .fbSettingsListItem:eq(1) ._nlm",
                  valueType: "inner"
              }
          },
            write:{
                name:"Who can see posts you've been tagged in on your timeline?",
                page:"https://www.facebook.com/settings?tab=timeline&section=tagging&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                availableSettings: {
                    everyone:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787530733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787530733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787530733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    },
                    friends_except_acquaintances:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787530733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_except_acquaintances
                            }
                        },
                        name: "Friends except Acquaintances"
                    },
                    only_me:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787530733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.only_me
                            }
                        },
                        name: "Only Me"
                    }

                },
                recommended:"only_me"
            }
        },

        timeline_other_posts:{
            read:{
                name: "Who can see what others post on your timeline?",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings: {
                    everyone: {
                        name: "Everyone"
                    },
                    friends_of_friends:{
                        name:"Friends of Friends"
                    },
                    friends:{
                        name:"Friends"
                    },
                    friends_except_acquaintances:{
                        name:"Friends except Acquaintances"
                    },
                    only_me:{
                        name:"Only Me"
                    }

                },
                jquery_selector:{
                    element:".fbSettingsList:eq(1) .fbSettingsListItem:eq(2) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can see what others post on your timeline?",
                page:"https://www.facebook.com/settings?tab=timeline&section=others&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                availableSettings: {
                    everyone:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787370733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787370733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787370733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    },
                    friends_except_acquaintances:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787370733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_except_acquaintances
                            }
                        },
                        name: "Friends except Acquaintances"
                    },
                    only_me:{
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787370733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.only_me
                            }
                        },
                        name: "Only Me"
                    }

                },
                recommended:"only_me"
            }

        },

        photo_tags_audience:{
            read:{
                name: "When you are tagged in a post, whom do you want to add to the audience if they are not already in it?",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings:{
                    friends:{
                        name:"Friends"
                    },
                    only_me:{
                        name:"Only Me"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name: "When you are tagged in a post, whom do you want to add to the audience if they are not already in it?",
                page:"https://www.facebook.com/settings?tab=timeline&section=expansion&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
                availableSettings:{
                    friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787795733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    },
                    only_me: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787795733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.only_me
                            }
                        },
                        name: "Only Me"
                    }
                },
                recommended:"only_me"
            }
        },
        /*control_tag_suggestions:{
            //It seems not to be available for EUROPE
            read:{
                name: "Control who sees tag suggestions when photos that look like you are uploaded",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings:{
                    friends:{
                        name:"Friends"
                    },
                    only_me:{
                        name:"Only Me"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(2) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                recommended:"only_me"
            }
        },*/
        control_followers:{
            read:{
                name: "Control who can be your follower.",
                url: "https://www.facebook.com/settings?tab=followers",
                availableSettings: {
                    friends: {
                        name: "Friends"
                    },
                    public: {
                        name: "Public"
                    }
                },
                jquery_selector:{
                    element: "span[class='_55pe']", //TODO: Find better way of reading value.
                    valueType: "inner"
                }
            },
            write:{
                name:"Who Can Follow Me",
                url_template:"https://www.facebook.com/ajax/follow/enable_follow.php?dpr=1",
                page: "https://www.facebook.com/settings?tab=followers",
                availableSettings: {
                    friends: {
                        data:{
                            allow_subscribers:'disallow',
                            should_inject:''
                        },
                        name:"Friends"
                    },
                    public: {
                        data: {
                            allow_subscribers: 'allow',
                            should_inject:1
                        },
                        name:"Public"
                    }
                },
                data: {
                    location: 44,
                    hideable_ids: ["#following_plugin_item", "#following_editor_item"]
                },
                recommended:"friends"
            }
        },
        permissions_for_apps:{
            read:{
                name: "Set permissions for data access by the apps that you use",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Friends", "Everyone"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disable all permissions"
            }
        },
        see_apps:{
            read:{
                name: "Control who on Facebook can see that you use this app",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Public", "Friends of Friends","Friends", "Only Me"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        allow_apps:{
            read:{
                name: "Allow or disallow use of apps, plugins, games and websites on Facebook and elsewhere.",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings: {
                    disabled: {
                        name: "Disalow"
                    },
                    enabled: {
                        name: "Allow"
                    }
                },
                jquery_selector:{
                    element:"._3q72",
                    valueType: "inner"
                }
            },
            write:{
                name:"Allow or disallow use of apps, plugins, games and websites on Facebook and elsewhere.",
                page:"https://www.facebook.com/settings?tab=applications",
                url_template:"https://www.facebook.com/settings/application/platform_opt_out/submit/?action={ACTION}&dpr=1",
                availableSettings: {
                    enabled:{
                        params:{
                            action:{placeholder:"ACTION",
                            value:"enable"
                            }
                        },
                        name:"Enabled."
                    },
                    disabled:{
                        params:{
                            action:{placeholder:"ACTION",
                                value:"disable"
                            }
                        },
                        name:"Disabled."
                    }

                },
                recommended:"disabled"
            }
        },
        control_personal_info:{
            read:{
                name: "Control what personal info of yours your friends can bring with them when they use apps, games and websites ",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Allow", "Disallow"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not allow any"
            }
        },
        control_outdated_clients:{
            read:{
                name: "Who will see things you post using old Facebook mobile apps that do not have the inline audience selector, such as outdated versions of Facebook for BlackBerry?",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Public", "Friends of Friends","Friends", "Only Me"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        control_ads:{
            read:{
                name: "Allow Facebook to show you ads based on your use of websites and apps that use Facebook's technologies ",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings: {
                    yes: {
                        name: "Yes"
                    },
                    no: {
                        name: "No"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Ads based on my use of websites and apps",
                page:"https://www.facebook.com/settings?tab=ads&section=oba&view",
                url_template:"https://www.facebook.com/ads/preferences/oba/?dpr=1",
                availableSettings:{
                    yes:{
                        data:{
                            is_opted_out:0
                        },
                        name:"Yes"
                    },
                    no:{
                        data:{
                            is_opted_out:1
                        },
                        name:"No"
                    }
                },

                recommended:"no"
            }
        },
        facebook_companies_ads:{
            read:{
                name:"Can your Facebook ad preferences be used to show you ads on apps and websites off of the Facebook Companies?",
                url:"https://www.facebook.com/settings?tab=ads&view",
                availableSettings: {
                    yes: {
                        name: "Yes"
                    },
                    no: {
                        name: "No"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }

            },
            write:{
                name:"Can your Facebook ad preferences be used to show you ads on apps and websites off of the Facebook Companies?",
                page:"https://www.facebook.com/settings?tab=ads&section=fpd&view",
                url_template:"https://www.facebook.com/ads/preferences/fpd/?dpr=1",
                availableSettings:{
                    yes:{
                        data:{
                            is_opted_out:0
                        },
                        name:"Yes"
                    },
                    no:{
                        data:{
                            is_opted_out:1
                        },
                        name:"No"
                    }
                },

                recommended:"no"
            }
        },
        control_friends_ads:{
            read:{
                name: "Who can see your social actions paired with ads?",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings: {
                    only_friends: {
                        name: "Only my friends"
                    },
                    no_one: {
                        name: "No one"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can see your social actions paired with ads?",
                page:"https://www.facebook.com/settings?tab=ads&section=socialcontext&view",
                url_template:"https://www.facebook.com/ajax/settings/ads/socialcontext.php?dpr=1",
                availableSettings:{
                    only_friends:{
                        data:{
                            opt_out:''
                        },
                        name:"Only my friends"
                    },
                    no_one:{
                        data:{
                            opt_out:1
                        },
                        name:"No one"
                    }
                },

                recommended:"no_one"
            }
        },
        control_preferences:{
            read:{
                name: "Control preferences Facebook  created for you based on things like your profile information, actions you take on Facebook and websites and apps you use off Facebook ",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings:["Remove all preferences", "Allow"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Remove all preferences created by Facebook"
            }
        },
        allow_email_share:{
            read:{
                name: "Allow or disallow friends to include your email address in \"download your information\"",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Allow", "Disallow"],
                jquery_selector:{
                    //TODO: Current setting does not corresponds with actual setting in page.
                }
            },
            write:{
                recommended:"Disallow"
            }
        }

    },

    "google": {
        keep_app_activity:{
            read:{
                name: "Delete or keep all Web and app activity",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='search'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        keep_audiovideo_activity:{
            read:{
                name: "Delete or keep all Voice and Audio activity",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='audio'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        keep_device_activity:{
            read:{
                name: "Delete or keep device activity info",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='device'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        keep_location_history:{
            read:{
                name: "Delete or keep your entire location history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='location'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        keep_youtube_history:{
            read:{
                name: "Delete or keep YouTube watch history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='youtubeWatch'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        keep_youtube_searches:{
            read:{
                name: "Delete or keep YouTube search history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='youtubeSearch'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        check_unused_apps:{
            read:{
                name: "Apps connected to your acccount ",
                url: "https://security.google.com/settings/security/permissions",
                jquery_selector:{
                    element:"div.Y5KHCd",
                    valueType:"length"
                    //TODO: return a string "List has applications" or "List has n applications".
                }
            },
            write:{
                recommended:"Revoke access by unused applications"
            }
        },
        /*share_location:{
            read:{
                name: "Allow/disallow  sharing your location with Google and other users",
                url: "https://myaccount.google.com/privacy#accounthistory",
                jquery_selector:{
                    //TODO: Not applicable.
                }
            },
            write:{
                recommended:"Disallow"
            }
        },*/
        /*keep_history:{
            read:{
                name: "Turn on/off Google collecting your search and browsing activity ",
                url: "https://myaccount.google.com/privacy#accounthistory",
                jquery_selector:{
                    //TODO: Not applicable.
                }
            },
            write:{
                recommended:"Off"
            }
        },*/
        pause_location_tracking:{
            read:{
                name: "Pause Google and related apps tracking your location. ",
                url: "https://myaccount.google.com/activitycontrols/location",
                jquery_selector:{
                    element:"div[data-aid='location'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        },
        //TODO: Added on 22/7/2016. See if it should be kept.
        turn_off_adds_based_on_your_interest:{
            read:{
                name: "Turn off ads based on your interest",
                url: "https://www.google.com/settings/u/0/ads/authenticated",
                jquery_selector: {
                    element: "div.Pu > span.iI > div[aria-checked]",
                    valueType: "attrValue",
                    attrValue: "aria-checked"
                }
            },
            write:{
                recommended:"false"
            }
        }
    },

    "linkedin": {
        //=============================================================================================================
        //================================================Account======================================================
        //=============================================================================================================
        control_third_party:{
            read:{
                name: "Third party apps",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{
                    element:"li[id='setting-third-party-applications'] .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Manual review and removal of redundant apps"
            }
        },
        manage_twitter:{
            read:{
                name: "Manage your Twitter info and activity on your LinkedIn account",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{
                    element:"li[id='setting-twitter'] .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Do not connect to Twitter"
            }
        },
        manage_wechat:{
            read:{
                name: "setting-wechat",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{
                    element:"li[id='setting-wechat'] .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Not connected"
            }
        },
        //=============================================================================================================
        //================================================Privacy======================================================
        //=============================================================================================================
        share_edits:{
            read:{
                name: "Sharing profile edits?",
                url: "https://www.linkedin.com/psettings/activity-broadcast",
                availableSettings:{
                  yes:{
                      name:"Yes"
                  },
                  no:{
                      name:"No"
                  }
                },
                jquery_selector:{
                    element:"input[id='option-broadcast']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Do not allow your network to be notified of your profile changes"
            }
        },
        suggest_you_email:{
            read:{
                name: "Suggesting you on the connection based on your email address",
                url: "https://www.linkedin.com/psettings/visibility/email",
                jquery_selector:{
                    element:"#setting-visibility-email .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Nobody"
            }
        },
        suggest_you_phone:{
            read:{
                name: "Suggesting you as a connection based on your phone number",
                url: "https://www.linkedin.com/psettings/visibility/phone",
                jquery_selector:{
                    element:"#setting-visibility-phone .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Nobody"
            }
        },
        share_data_with_third_party_applications:{
            read:{
                name: "Sharing data with third parties applications",
                url: "https://www.linkedin.com/psettings/data-sharing",
                jquery_selector:{
                    element:"input[id='option-block-applications']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        },
        share_data_with_third_party_platforms:{
            read:{
                name: "Sharing data with third parties platforms",
                url: "https://www.linkedin.com/psettings/data-sharing",
                jquery_selector:{
                    element:"input[id='option-block-platforms']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"no"
            }
        },
        cookie_personalised_ads:{
            read:{
                name: "Use cookies to personalize ads",
                url: "https://www.linkedin.com/psettings/enhanced-advertising",
                jquery_selector:{
                    element:"input[id='option-ads-choices']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        },
        share_you_news:{
            read:{
                name: "Allow or disallow your connections and followers to know when you are mentioned in the news.",
                url: "https://www.linkedin.com/psettings/news-mention-broadcast",
                jquery_selector:{
                    element:"input[id='option-news-mention']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        },
        broadcast_activity:{
            read:{
                name: "Allow or disallow your activity broadcasts.",
                url: "https://www.linkedin.com/psettings/activity-broadcast",
                jquery_selector:{
                    element:"input[id='option-broadcast']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        },
        control_broadcast:{
            read:{
                name: "Control who can see your activity broadcast.",
                url: "https://www.linkedin.com/psettings/allow-follow",
                jquery_selector:{
                    element:"#setting-allow-follow .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Connections"
            }
        },
        /*control_others_see:{
         read:{
         name: "Control what others see when you have viewed their profile",
         url: "https://www.linkedin.com/psettings/account",
         jquery_selector:{
         }
         },
         write:{
         recommended:"Limit to your name and headline"
         }
         },*/
        how_you_rank:{
            read:{
                name: "Control showing “How You Rank”",
                url: "https://www.linkedin.com/psettings/how-you-rank",
                jquery_selector:{
                    element:"#setting-how-you-rank .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"No"
            }
        },
        see_connections_list:{
            read:{
                name: "Select who can see your list of connections.",
                url: "https://www.linkedin.com/psettings/connections-visibility",
                jquery_selector:{
                    element:"#setting-connections-visibility .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Only you"
            }
        },
        linkedin_control_followers:{
            read:{
                name: "Control who can follow your updates.",
                url: "https://www.linkedin.com/psettings/allow-follow",
                jquery_selector:{
                    element:"option",
                    valueType:"selected"
                }
            },
            write:{
                recommended:"Limit to your connections"
            }
        },
        control_profile_photo:{
            read:{
                name: "Control your profile photo and visibility.",
                url: "https://www.linkedin.com/psettings/profile-photo-visibility",
                jquery_selector:{
                    element:"#setting-profile-photo-visibility .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"Connections"
            }
        },
        /*control_also_viewed:{
         read:{
         name: "Control display of 'Viewers of this profile also viewed' box on your Profile page.",
         url: "https://www.linkedin.com/psettings/account",
         jquery_selector:{
         }
         },
         write:{
         recommended:"Do not display"
         }
         },*/
        /*contrl_phone_info:{
         read:{
         name: "Control how your phone number can be used.",
         url: "https://www.linkedin.com/psettings/account",
         jquery_selector:{
         }
         },
         write:{
         recommended:"Limit to your 1st degree connections"
         }
         },*/
        /*meet_the_team:{
         read:{
         name: "Control “Meet the team”",
         url: "https://www.linkedin.com/psettings/account",
         jquery_selector:{
         }
         },
         write:{
         recommended:"Disallow"
         }
         },*/
        //=============================================================================================================
        //================================================Communications===============================================
        //=============================================================================================================
        control_messages_invitations:{
            read:{
                name: "Control whether you're willing to receive invitations to join your network.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='invitationsGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_messages:{
            read:{
                name: "Control whether you're willing to receive messages from other LinkedIn members.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='messagesGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_notifications:{
            read:{
                name: "Control whether you're willing to receive news and activity related to your profile " +
                "and what you share.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='notificationsGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_network_updates:{
            read:{
                name: "Control whether you're willing to receive Updates about your connections.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='updatesFromNetworkGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_jobs_and_opportunities:{
            read:{
                name: "Control whether you're willing to receive Updates about Jobs and opportunities.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='jobSeekerGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_news:{
            read:{
                name: "Control whether you're willing to receive News and articles relevant to you.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='newsGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_group_updates:{
            read:{
                name: "Control whether you're willing to receive News about what's going on in your groups.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='groupsNode']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_from_linkedIn:{
            read:{
                name: "Control whether you're willing to receive occasional emails with tips and offers " +
                "to help you get the most out of LinkedIn.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='messagesFromLinkedinGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        control_messages_from_linkedIn_learning:{
            read:{
                name: "Control whether you're willing to receive recommendations to help you get the most " +
                "out of LinkedIn Learning.",
                url: "https://www.linkedin.com/psettings/email-controls",
                jquery_selector:{
                    element:"input[id='messagesFromLearningGroup']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:undefined
            }
        },
        who_can_invite_you:{
            read:{
                name: "Select who can send you invitations",
                url: "https://www.linkedin.com/psettings/invite-receive",
                jquery_selector:{
                    element:"li[id='setting-invite-receive'] .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:undefined
            }
        },
        /*messages_from_members:{
         read:{
         name: "Select what type of member messages you'd prefer to receive",
         url: "https://www.linkedin.com/psettings/message-preferences",
         jquery_selector:{
         //TODO: See if this setting is required?
         }
         },
         write:{
         recommended:undefined
         }
         },*/
        enable_group_invitations:{
            read:{
                name: "Choose whether you want to receive invitations to join groups",
                url: "https://www.linkedin.com/psettings/group-invitations",
                jquery_selector:{
                    element:"#setting-group-invitations .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:undefined
            }
        },
        enable_group_notifications:{
            read:{
                name: "Choose whether we notify your network when you join a group",
                url: "https://www.linkedin.com/psettings/group-join-notifications",
                jquery_selector:{
                    element:"#setting-group-join-notifications .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:undefined
            }
        },
        enable_research_invitations:{
            read:{
                name: "Turn on/off invitations to participate in research",
                url: "https://www.linkedin.com/psettings/research-invitations",
                jquery_selector:{
                    element:"#setting-research-invitations .state",
                    valueType:"inner"
                }
            },
            write:{
                recommended:"No"
            }
        },
        allow_partner_inmail:{
            read:{
                name: "Allow or disallow Partner InMail",
                url: "https://www.linkedin.com/psettings/partner-inmail",
                jquery_selector:{
                    element:"input[id='option-partner-inmail-marketing']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        },
        allow_hiring_campaign_partner_inmail:{
            read:{
                name: "Allow or disallow hiring campaign Partner InMail",
                url: "https://www.linkedin.com/psettings/partner-inmail",
                jquery_selector:{
                    element:"input[id='option-partner-inmail-hiring']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"false"
            }
        }
    },

    "twitter": {
        allow_login_verification:{
            read:{
                name: "Allow/disallow Login verification (a phone must be added first).",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='login_verification']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Allow"
            }
        },
        allow_password_reset:{
            read:{
                name: "Allow/disallow further personal information for Password reset.",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='user_no_username_only_password_reset']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Allow"
            }
        },
        allow_login_with_code_1:{
            read:{
                name: "Allow/disallow login to your account with either a password or login code.",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='one_factor_optout_settings_off']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_login_with_code_2:{
            read:{
                name: "Allow/disallow to always require a password to log to your account.",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='one_factor_optout_settings_on']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Allow"
            }
        },

        tweet_privacy:{
            read:{
                name: "Allow/disallow only those you approve to receive your Tweets.",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='user_protected']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Allow"
            }
        },
        allow_location:{
            read:{
                name: "Enable Twitter to add your location to your tweets.",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='user_geo_enabled']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disabled"
            }
        },
        allow_email_search:{
            read:{
                name: "Allow/disallow others find you by your email address",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='user_discoverable_by_email']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_phone_search:{
            read:{
                name: "Allow/disallow others find you by your phone number",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='user_mobile_discoverable']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_promoted_content:{
            read:{
                name: "Allow/disallow Twitter to display ads about things you've already shown " +
                "interest in (aka “promoted content”",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='allow_ads_personalization']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        //=============================================================================================================
        //=============================================================================================================
        //=============================================================================================================
        //TODO: Find a better way of reading this setting.
        allow_tweetdeck_1:{
            read:{
                name: "Allow/disallow organizations to invite anyone to tweet from their account using " +
                "the teams feature in TweetDeck (1 option).",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='allow_contributor_request_all']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_tweetdeck_2:{
            read:{
                name: "Allow/disallow organizations to invite anyone to tweet from their account using " +
                "the teams feature in TweetDeck (1 option).",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='allow_contributor_request_following']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_tweetdeck_3:{
            read:{
                name: "Allow/disallow organizations to invite anyone to tweet from their account using " +
                "the teams feature in TweetDeck (1 option).",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='allow_contributor_request_none']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Allow"
            }
        },
        //=============================================================================================================
        //=============================================================================================================
        //=============================================================================================================
        allow_direct_message:{
            read:{
                name: "Allow/disallow any Twitter user to send you a direct message even if you do not follow them",
                url: "https://twitter.com/settings/security",
                jquery_selector:{
                    element:"input[id='allow_dms_from_anyone']",
                    valueType:"checkbox"
                }
            },
            write:{
                recommended:"Disallow"
            }
        }
    }
}
 
 return JSON.stringify(ospSettingsConfig);
 
 })()
