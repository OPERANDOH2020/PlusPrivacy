module.exports = function(grunt){
    var path = require('path');
    var browser = grunt.option("browser")||'chrome';

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        copy: {
            main: {
                src: ['**/*','!**/libs/**','!manifest*'],
                expand: true,
                cwd: 'operando',
                dest: 'dist'
            },
            manifest:{
                src:["manifest-"+browser.toLocaleLowerCase()+".json"],
                expand: true,
                cwd: 'operando',
                dest:"dist",
                rename: function(dest, src) {
                    return dest+"/" + src.replace("-"+browser.toLocaleLowerCase(),'');
                }

            }
        },

        concat: {
            dashboard_directives: {
                src:[
                    "operando/directives/dashboard/deals.js",
                    "operando/directives/dashboard/extensions.js",
                    "operando/directives/dashboard/social-apps.js",
                    "operando/directives/dashboard/identities.js",
                    "operando/directives/dashboard/notification.js",
                    "operando/directives/dashboard/osp-settings.js",
                    "operando/directives/dashboard/single-click-privacy.js",
                    "operando/directives/dashboard/abp_data_leakage_prevention.js",
                    "operando/directives/dashboard/progress-bar.js",
                    "operando/directives/dashboard/setting-editor.js",
                    "operando/directives/dashboard/loader.js",
                    "operando/directives/dashboard/change-state-if.js",
                    "operando/directives/dashboard/how-it-works.js",
                    "operando/directives/dashboard/login.js"
                ],
                dest:"dist/directives/dashboard-directives.js"
            },
            popup_directives: {
                src:["operando/directives/popup/popup_menu.js"],
                dest:"dist/directives/popup-directives.js"
            },
            swarm_services:{
              src:[
                  "operando/services/swarm-services/socket.io-2.0.3.js",
                  "operando/util/Constants.js",
                  "operando/services/swarm-services/SwarmDebug.js",
                  "operando/services/swarm-services/SwarmClient.js",
                  "operando/services/swarm-services/SwarmHub.js",
                  "operando/backgrounds/utils/polyglot.min.js"
              ],
                dest:"dist/backgrounds/swarm-services.js"
            },
            background_services: {
                src:[
                    "build/operando/backgrounds/utils/RegexUtils.js",
                    "build/operando/libs/observers-pool.js",
                    "build/operando/libs/bus-service.js",
                    "build/operando/libs/swarm-service.js",
                    "build/operando/libs/identity-service.js",
                    "build/operando/libs/device-service.js",
                    "build/operando/libs/i18n-service.js",
                    "build/operando/libs/notification-service.js",
                    "build/operando/libs/authentication-service.js",
                    "build/operando/libs/pfb-service.js",
                    "build/operando/libs/social-network-privacy-settings.js",
                    "build/operando/libs/osp-service.js",
                    "build/operando/modules/Interceptor.js",
                    "build/operando/libs/request-intercepter-service.js",
                    "build/operando/libs/user-service.js",
                    "build/operando/libs/social-network-service.js",
                    "build/operando/libs/website-service.js",
                    "build/operando/libs/script-injector-service.js",
                    "build/operando/libs/popup-service.js",
                    "build/operando/modules/SynchronizedPersistence.js",
                    "build/operando/util/DependencyManager.js",
                    "build/operando/modules/TabsManager.js"
                ],
                dest:"dist/backgrounds/background-services.js"
            },
            config:{
                src:["build/config/*"],
                dest:"dist/backgrounds/utils/Config.js"
            }
        },

        wrap: {
            advanced: {
                expand: true,
                src: [
                    "operando/backgrounds/utils/RegexUtils.js",
                    "operando/libs/observers-pool.js",
                    "operando/libs/bus-service.js",
                    "operando/libs/swarm-service.js",
                    "operando/libs/identity-service.js",
                    "operando/libs/device-service.js",
                    "operando/libs/i18n-service.js",
                    "operando/libs/notification-service.js",
                    "operando/libs/authentication-service.js",
                    "operando/libs/pfb-service.js",
                    "operando/libs/social-network-privacy-settings.js",
                    "operando/libs/osp-service.js",
                    "operando/modules/Interceptor.js",
                    "operando/libs/request-intercepter-service.js",
                    "operando/libs/user-service.js",
                    "operando/libs/social-network-service.js",
                    "operando/libs/website-service.js",
                    "operando/libs/script-injector-service.js",
                    "operando/libs/popup-service.js",
                    "operando/modules/SynchronizedPersistence.js",
                    "operando/util/DependencyManager.js",
                    "operando/modules/TabsManager.js"
                ],
                dest: 'build',
                options: {
                    seperator: '\n',
                    indent: '\t',
                    wrapper: function(filepath) {
                        var filename = path.basename(filepath,'.js');
                        return ['require.scopes["'+filename+'"] = (function()\n{\n\tvar exports = {};\n','\n return exports;\n})();\n'];
                    }
                }
            }
        },
        clean:{
            build:[
                "build",
                "dist/directives/dashboard",
                "dist/directives/popup",
                "dist/services/swarm-services",
                "dist/util/config"
            ],
            release:{
                options:{
                    'no-write': true
                },
                src: ['operando']
            }
        },

        config: {
            dev: {
                options: {
                    variables: {
                        'environment': 'operando/util/config/Config.debug.js'
                    }
                }
            },
            prod: {
                options: {
                    variables: {
                        'environment': 'operando/util/config/Config.production.js'
                    }
                }
            },
            test: {
                options: {
                    variables: {
                        'environment': 'operando/util/config/Config.testServer.js'
                    }
                }
            }
        },

        replace: {
            dist: {
                options: {
                    variables: {
                        'environment': '<%= grunt.config.get("environment") %>'
                    },
                    force: true
                },
                files: [
                    {expand: true, flatten: true, src: ['<%= grunt.config.get("environment") %>'], dest: 'build/config'}
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-wrap');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-config');
    grunt.loadNpmTasks('grunt-replace');

    grunt.registerTask('default', ['config:dev','replace','copy','wrap','concat','clean']);
    grunt.registerTask('test', ['config:test','replace','copy','wrap','concat','clean']);
    grunt.registerTask('release', ['config:prod','replace','copy','wrap','concat','clean']);
}
