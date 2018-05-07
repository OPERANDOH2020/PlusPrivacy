module.exports = function(grunt){
    var path = require('path');
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),


        copy: {
            main: {
                src: ['**/*','!**/libs/**'],
                expand: true,
                cwd: 'operando',
                dest: 'dist'
            }
        },

        concat: {
            directives: {
                src:[
                    "operando/directives/deals.js",
                    "operando/directives/extensions.js",
                    "operando/directives/social-apps.js",
                    "operando/directives/identities.js",
                    "operando/directives/notification.js",
                    "operando/directives/osp-settings.js",
                    "operando/directives/single-click-privacy.js",
                    "operando/directives/abp_data_leakage_prevention.js",
                    "operando/directives/progress-bar.js",
                    "operando/directives/setting-editor.js",
                    "operando/directives/loader.js",
                    "operando/directives/change-state-if.js",
                    "operando/directives/how-it-works.js",
                    "operando/directives/login.js"
                ],
                dest:"dist/directives.js"
            },
            libs: {
                src:[
                    "build/operando/util/RegexUtils.js",
                    "build/operando/libs/observers-pool.js",
                    "build/operando/libs/bus-service.js",
                    "build/operando/libs/swarm-service.js",
                    "build/operando/libs/identity-service.js",
                    "build/operando/libs/device-service.js",
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
                dest:"dist/server.js"
            }
        },

        wrap: {
            advanced: {
                expand: true,
                src: [
                    "operando/util/RegexUtils.js",
                    "operando/libs/observers-pool.js",
                    "operando/libs/bus-service.js",
                    "operando/libs/swarm-service.js",
                    "operando/libs/identity-service.js",
                    "operando/libs/device-service.js",
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
                        console.log(filename);
                        return ['require.scopes["'+filename+'"] = (function()\n{\n\tvar exports = {};\n','\n return exports;\n})();\n'];
                    }
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-wrap');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-copy');

    // Default task(s).
    grunt.registerTask('min', ['concat']);
    grunt.registerTask('wrapper', ['wrap','concat']);
    grunt.registerTask('mirror', ['copy']);
    grunt.registerTask('build', ['copy','wrap','concat']);

}
