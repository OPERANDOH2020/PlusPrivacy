module.exports = function(grunt){
    var path = require('path');
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        concat: {
            directives: {
                src:"operando/directives/*",
                dest:"directives.min.js"
            },
            libs: {
                src:["dist/operando/modules/*","dist/operando/libs/*","dist/operando/util/*"],
                dest:"server.js"
            }
        },

        wrap: {
            advanced: {
                expand: true,
                src: ['operando/libs/*.js','operando/util/RegexUtils.js','operando/modules/Interceptor.js','operando/modules/SynchronizedPersistence.js','operando/modules/TabsManager.js'],
                dest: 'dist',
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

    // Default task(s).
    grunt.registerTask('min', ['concat']);
    grunt.registerTask('wrapper', ['wrap','concat']);
}
