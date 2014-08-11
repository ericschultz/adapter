module.exports = (grunt) ->

    grunt.task.loadNpmTasks 'grunt-contrib-coffee'
    grunt.task.loadNpmTasks 'grunt-contrib-watch'
    grunt.task.loadNpmTasks 'grunt-coffeelint'
    grunt.task.loadNpmTasks 'grunt-contrib-clean'

    grunt.initConfig
        pkg:
            grunt.file.readJSON('package.json')

        coffee:
          dist:
            files:
              [
                {
                  expand: true,
                  cwd: 'lib',
                  src: ['**/*.coffee'],
                  dest: 'lib/',
                  ext: '.js'
                },
                {
                  expand: true,
                  cwd: 'test',
                  src: ['**/*.coffee'],
                  dest: 'test/',
                  ext: '.js'
                },
              ]
        coffeelint:
          dist:
            files:
              src: ['lib/*.coffee', 'test/*.coffee']

          options:
            no_tabs:
              level: 'ignore'
            indentation:
              level: 'ignore'

        clean: ['lib/**/*.js', 'test/**/*.js']

        watch:
            dist:
                files: '*.coffee'
                tasks: [ 'coffeelint', 'coffee:dist', 'mochaTest:dist' ]

    grunt.event.on 'coffee.error', (msg) ->
        grunt.log.write msg

    grunt.registerTask 'test', ['coffeelint', 'coffee']
    grunt.registerTask 'default', ['coffeelint', 'coffee']
    grunt.registerTask 'dev', ['watch']
