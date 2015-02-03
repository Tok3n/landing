path = require('path')

siblingArray = (arr, key, match) ->
	matches = arr.filter((val, index, array) ->
		val[key] is match
	)
	return matches

module.exports = (grunt) ->	

	cachebuster = Math.round(new Date().getTime() / 1000)
	
	configFile = grunt.file.readJSON 'config.json'
	# current config will be the configuration with the parameter "Current" set as "true".
	currentConfig = siblingArray(configFile, "Current", "true")[0]
	configName = grunt.option("config") || currentConfig.Name
	
	src = path.join(process.cwd(), "src/landing")
	build = path.join(process.cwd(), "builds/#{configName}/landing")
	comp = path.join(process.cwd(), "components")
	
	# Maybe add support for grunt.option
	localhost = "#{currentConfig.Protocol}://#{currentConfig.Platform_host}#{currentConfig.BrowserPath}"
	
	web = "#{src}/web"
	dist = "#{src}/dist"
	dartBuildProd = "#{src}/build/web"
	views = "#{src}/views"
	dartPkg = "#{src}/packages"

	css = "#{web}/css"
	sass = "#{web}/sass"
	js = "#{web}/js"
	img = "#{web}/img"
	coffee = "#{web}/coffee"
	dart = "#{web}/dart"
	svg = "#{web}/svg"
	html = "#{web}/html"
	fonts = "#{css}/fonts"

	webBuild = "#{build}/web"
	cssBuild = "#{webBuild}/css"
	sassBuild = "#{webBuild}/sass"
	jsBuild = "#{webBuild}/js"
	imgBuild = "#{webBuild}/img"
	fontBuild = "#{webBuild}/font"
	coffeeBuild = "#{webBuild}/coffee"
	dartBuild = "#{webBuild}/dart"
	dartPkgBuild = "#{webBuild}/packages"
		
	# Regex
	css_file = /([^\/]+)\.css$/

	@initConfig
		
		# Versions, names for licenses
		pkg: grunt.file.readJSON 'package.json'

		##############################################
		# Build external files (js and css)

		# curl:
		# 	buoy:
		# 		dest: "#{js}/buoy.js"
		# 		src: 'https://raw.githubusercontent.com/jshthornton/buoy.js/9b177618b11d883e0af50b31ec321fdf7f80c736/src/buoy.js'

		##############################################

		compass:
			options:
				require: ['breakpoint-slicer', 'animate']
				cssPath: css
				sassPath: sass
				imagesPath: img
				fontsPath: fonts
				javascriptsPath: js
				cssDir: "css"
				sassDir: "sass"
				imagesDir: "img"
				fontsDir: "css/fonts"
				javascriptsDir: "js"
				relativeAssets: true
				force: true
				raw: """
				preferred_syntax = :sass
				::Sass::Script::Number.precision = [10, ::Sass::Script::Number.precision].max
				sass_options = {:quiet => true}

				"""
			dev:
				options:
					outputStyle: 'expanded'
			prod:
				options:
					outputStyle: 'compressed'
		
		##############################################
		
		coffeelint:
			app:
				files:
					src: ["#{coffee}/**/*.coffee"]
				options:
					configFile: 'coffeelint.json'

		coffee: 
			options:
				bare: true
			glob:
				expand: true
				cwd: coffee
				src: ["**/*.coffee"]
				dest: js
				ext: '.js'

		concat:
			options:
				separator: '\n'
			utils:
				src: [
					comp + '/jquery/dist/jquery.js'
					js + '/domready.js'
				]
				dest: js + '/utils.js'

		uglify:
			options:
				mangle: true
				compress: true
				report: 'gzip'
				preserveComments: 'some'
				banner: [
					'/*!'
					' * <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>'
					' * <%= pkg.description %>'
					' * Automatically generated by Grunt.js'
					' */\n'
				].join '\n'
			utils:
				src: '<%= concat.utils.dest %>'
				dest: "#{js}/utils-min.js"

		##############################################

		jade:
			dev:
				options:
					# data: currentConfig
					debug: false
					pretty: true
				files: [{
					expand: true
					cwd: views
					src: '**/*.jade'
					dest: "#{html}/"
					ext: ".html"
				}]
			prod:
				options:
					debug: false
					pretty: true
				files: [{
					expand: true
					cwd: views
					src: '**/*.jade'
					dest: "#{html}/"
					ext: ".html"
				}]

		processhtml:
			options:
				process: true
			all:
				expand: true
				cwd: html
				src: '**/*.html'
				dest: html
				ext: ".html"

		##############################################

		copy:
			html:
				src: "#{html}/index.html"
				dest: "#{web}/index.html"


		##############################################

		replace:
			options:
				usePrefix: false
				overwrite: true
				excludeBuiltins: true
				patterns: [
					{
						match: "{[{Tok3n_PlatformHost}]}"
						replacement: currentConfig.Platform_host
					}
					{
						match: "{[{Tok3n_Protocol}]}"
						replacement: currentConfig.Protocol
					}
					{
						match: "{[{Tok3n_PublicKey}]}"
						replacement: currentConfig.Key_public
					}
					{
						match: "{[{Tok3n_SecretKey}]}"
						replacement: currentConfig.Key_secret
					}
					{
						match: "{[{Tok3n_AppName}]}"
						replacement: currentConfig.App
					}
					{
						match: "{[{Tok3n_phase}]}"
						replacement: currentConfig.Usage
					}
					{
						match: "@@cachebuster"
						replacement: "#{cachebuster}"
					}
				]
			css:
				files: [
					{
						expand: true
						cwd: webBuild
						src: ["css/**/*"]
						dest: webBuild
					}
				]
			assets:
				files: [
					{
						expand: true
						cwd: webBuild
						src: ["packages/**/*", "*"]
						dest: webBuild
					}
				]
			js:
				files: [
					{
						expand: true
						cwd: webBuild
						src: ["js/**/*"]
						dest: webBuild
					}
				]
			html:
				files: [
					{
						expand: true
						cwd: webBuild
						src: ["html/**/*"]
						dest: webBuild
					}
				]
			dart:
				files: [
					{
						expand: true
						cwd: webBuild
						src: ["dart/**/*"]
						dest: webBuild
					}
				]
			serverFiles:
				files: [
					{
						expand: true
						cwd: "#{src}"
						src: ["makefile", "app.yaml", "index.yaml"]
						dest: build
					}
				]
			deep:
				files: [
					{
						expand: true
						cwd: build
						src: ["**", "!**/*.{png,gif,png,jpg,jpeg,svg,tif,tiff}", "!**/{img,images,fonts,font,image}/**"]
						dest: build
					}
				]

		##############################################

		sync:
			css:
				files: [
					{
						cwd: web
						src: ["css/**"]
						dest: webBuild
					}
				]
			assets:
				files: [
					{
						cwd: web
						src: ["css/fonts/**", "svg/**", "img/**", "packages/**", "*"]
						dest: webBuild
					}
				]
			js:
				files: [
					{
						cwd: web
						src: ["js/**"]
						dest: webBuild
					}
				]
			html:
				files: [
					{
						cwd: web
						src: ["html/**"]
						dest: webBuild
					}
				]
			dart:
				files: [
					{
						cwd: web
						src: ["dart/**"]
						dest: webBuild
					}
				]
			dartRemoteTest:
				files: [
					{
						cwd: web
						src: ["landing.dart", "dart/**", "packages/**"]
						dest: "#{build}/build/web"
					}
				]
			deep:
				files: [
					{
						cwd: src
						src: ["**"]
						dest: build
					}
				]
			serverFiles:
				files: [
					{
						cwd: "#{src}"
						src: ["makefile", "app.yaml", "index.yaml"]
						dest: build
					}
				]

		'file-creator':
			rootMakefile:
				"makefile": (fs, fd, done) ->
					fs.writeSync(fd, "all:\n\tmake -C #{build}")
					done()

		##############################################

		shell:
			options:
				stderr: true
			reloadChrome:
				command: "./reload_chrome.bash #{localhost}"
			sleep:
				command: 'sleep 1s'
			dart2js:
				command: "cd #{build} && pub build"
			rsyncAll:
				command: "rm -Rf #{build}/"

		##############################################

		watch:
			options:
				livereload: false

			'all-dev':
				files: "#{web}/**"
				tasks: "build-dev"
			'all-prod':
				files: "#{web}/**"
				tasks: "build-prod"

			sassDev:
				files: "#{sass}/**"
				tasks: ['compile-sass-dev', 'sync:css', 'replace:css', 'reload']
			coffeeDev:
				files: "#{coffee}/**"
				tasks: ['compile-coffee-dev', 'sync:js', 'replace:js', 'reload']
			jadeDev:
				files: "#{views}/**"
				tasks: ['compile-jade-dev', 'sync:html', 'replace:html', 'reload']
			dartDev:
				files: "#{dart}/**"
				tasks: ['sync:dart', 'replace:dart', 'reload']

			sassProd:
				files: "#{sass}/**"
				tasks: ['compile-sass-prod', 'sync:css', 'replace:css', 'reload']
			coffeeProd:
				files: "#{coffee}/**"
				tasks: ['compile-coffee-prod', 'sync:js', 'replace:js', 'reload']
			jadeProd:
				files: "#{views}/**"
				tasks: ['compile-jade-prod', 'sync:html', 'replace:html', 'reload']
			dartProd:
				files: "#{dart}/**"
				tasks: ['sync:dart', 'replace:dart', 'compile-dart-prod', 'reload']
			
			serverFiles:
				files: ["#{src}/makefile", "#{src}/app.yaml"]
				tasks: ['sync:serverFiles', 'replace:serverFiles', 'reload']
			assets:
				files: ["#{css}/**", "#{svg}/**", "#{img}/**", "#{dartPkg}/**", "#{web}/*", "#{js}/**"]
				tasks: ['sync:assets', 'replace:assets', 'reload']

	#######################################
	# Default tasks
	#######################################
	
	@registerTask 'default', [
		'build-dev'
	]

	#######################################
	# Server states
	#######################################

	@registerTask 'reload', [
		'shell:sleep'
		'shell:reloadChrome'
	]

	#######################################
	# Build
	#######################################
	
	@registerTask 'build-dev', [
		'shell:rsyncAll'
		'compile-sass-dev'
		'compile-coffee-dev'
		'compile-jade-dev'
		'sync:deep'
		'copy:html'
		'file-creator'
		'replace:deep'
		'reload'
	]
	@registerTask 'build-prod', [
		'shell:rsyncAll'
		'compile-sass-prod'
		'compile-coffee-prod'
		'compile-jade-prod'
		'sync:deep'
		'sync:dartRemoteTest'
		'copy:html'
		'file-creator'
		'replace:deep'
		'shell:dart2js'
		'shell:sleep'
	]
	# @registerTask 'build-external', [
	# 	'copy:jquery'
	# ]
	
	#######################################
	# Compile Dev
	#######################################
	
	@registerTask 'compile-sass-dev', [
		'compass:dev'
	]
	@registerTask 'compile-coffee-dev', [
		'coffeelint'
		'coffee'
		'concat'
	]
	@registerTask 'compile-jade-dev', [
		'jade:dev'
		'copy:html'
	]

	#######################################
	# Compile Prod
	#######################################

	@registerTask 'compile-sass-prod', [
		'compass:prod'
	]
	@registerTask 'compile-coffee-prod', [
		'coffeelint'
		'coffee'
		'concat'
		'uglify'
	]
	@registerTask 'compile-jade-prod', [
		'jade:prod'
		'processhtml'
		'copy:html'
	]
	@registerTask 'compile-dart-prod', [
		'shell:dart2js'
	]

	#######################################
	@loadNpmTasks 'grunt-contrib-compass'
	@loadNpmTasks 'grunt-coffeelint'
	@loadNpmTasks 'grunt-contrib-coffee'
	@loadNpmTasks 'grunt-contrib-concat'
	@loadNpmTasks 'grunt-contrib-uglify'
	@loadNpmTasks 'grunt-contrib-jade'
	@loadNpmTasks 'grunt-processhtml'
	@loadNpmTasks 'grunt-shell'
	@loadNpmTasks 'grunt-sync'
	@loadNpmTasks 'grunt-contrib-watch'
	@loadNpmTasks 'grunt-replace'
	@loadNpmTasks 'grunt-file-creator'
	@loadNpmTasks 'grunt-contrib-copy'
	@loadNpmTasks 'grunt-curl'
