# Tok3n/landing

### Current milestones
 - Do mobile
 - Make a/b tests
 - Integrate Google Analytics
 - Contact and about pages

### Not so urgent
 - Something

### Installation

Dependencies:

- Linux/Mac environment
- [Homebrew](http://brew.sh/)
- [rvm](https://rvm.io/)
- [nvm](https://github.com/creationix/nvm)
- [DartEditor](https://www.dartlang.org/tools/editor/)
- [gcloud cli](https://cloud.google.com/sdk/#Quick_Start)
- [golang](https://golang.org/doc/install)
- [Bower](http://bower.io/)
- [`pub build`](https://www.dartlang.org/tools/pub/installing.html) in your PATH
- A [google cloud account](https://cloud.google.com/) for remote testing (with billing enabled)
- A [configurated git account](https://help.github.com/articles/set-up-git/) on your computer, to be able to clone private repos and make contributions. As an alternative, you can use the [Github app for Mac](https://mac.github.com/).

Clone the repository:

```sh
git clone https://github.com/Tok3n/landing.git
```

Go to the folder "landing/Modules/default"

```sh
cd landing/Modules/default
```

Update the gcloud cli

```sh
gcloud components update app
```

It's highly recommended to use rvm and nvm. Using the ruby installed by default in your computer [is not a good idea](http://code.tutsplus.com/articles/why-you-should-use-rvm--net-19529). Remember to [install](https://rvm.io/rubies/installing) and [set up the default ruby](https://rvm.io/rubies/default) on rvm and [on nvm](https://github.com/creationix/nvm).

```sh
nvm use 0.10
rvm gemset create landing
rvm use 2.1.3@landing
```

### Create your config file
Create a config.json file based on the syntax of the config_example.json as follows:

```json
[
	{
		"Name":"development",
		"App":"tok3n-landing",
		"Protocol":"http",
		"Platform_host":"localhost:8080",
		"Key_public":"1234567890",
		"Key_secret":"0987654321",
		"Usage":"LOCAL",
		"Current": "true",
		"BrowserPath": "/index.html"
	},
	{
		"Name":"remote-test",
		"App":"tok3n-landing",
		"Protocol":"https",
		"Platform_host":"test-dot-tok3n-landing.appspot.com",
		"Key_public":"1234567890",
		"Key_secret":"0987654321",
		"Usage":"REMOTETEST",
		"Current": "false",
		"BrowserPath": "/index.html"
	},
	{
		"Name":"production",
		"App":"tok3n-landing",
		"Protocol":"https",
		"Platform_host":"tok3n-landing.appspot.com",
		"Key_public":"1234567890",
		"Key_secret":"0987654321",
		"Usage":"REMOTETEST",
		"Current": "false",
		"BrowserPath": "/index.html"
	}
]
```

Where:

- `"Name":` of your configuration, has to be all lowercase no spaces, this will also be the folder name in  `landing/Modules/default/builds`.
- `"App":` App is the name of the GAE App. When using remotetest as usage, this must match your existing created Application on App Engine.
- `"Platform_host":` the host where will be hosted the app. For local testing usually will be "localhost:8080". For Remote testing will be `something.appspot.com`. Please note that testing with the mobile app does not work on localhost, you'll have to set up a remote test.
- `"Protocol":` use "http" for local and "https" for remotetest and production
- `"Key_public":` the public key of your integration. Generate it with a strong crypto algorithm.
- `"Key_secret":` the Secret key of your integration. Generate it with a strong crypto algorithm.
- `"Usage":` `"LOCAL"` stands for the local development in localhost. `"REMOTETEST"` is an environment similar to production but in your own appengine app. `"PRODUCTION"` is our production server in `secure.tok3n.com`.
- `"Current":` The configuration that will be used for the compiler to build the project. There should only be one set to `"true"`.
- `"BrowserPath":` The path relative to `Platform_host` where you are previewing the app. This will be the path used for Chrome reload while using `foreman start`. Include a preceding slash

### Build the code
Run the following to initialize the development environment.

```sh
cd landing/Modules/default
gem install bundler
bundle install
npm install
bower install
```

Build the code. This is necessary at the beginning, when switching from Production mode to Development mode, or when the watch-compiler is not working.

```sh
grunt build-dev

# You can also override the "current" config using the flag:
grunt build-dev --config=development
```
If you have strange errors try the following command to [remove all broken symbolic links](http://stackoverflow.com/a/22099005) in the repository (Sometimes Dart causes this with it's' shitty Packages folder).

```sh
find . -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +

# Then compile again
grunt build-dev
```

Now you can start to watch-compile while you develop!


### Watch-compile

Start the server in one terminal window:

```sh
cd landing/Modules/default
make
# stop with Ctrl-c
```

Start the grunt watch-compiler in another terminal window. This will watch-compile in development mode:

```sh
cd landing/Modules/default
foreman start
# stop with Ctrl-c
```

To watch-compile in production mode:

```sh
foreman start -f Procfile.prod
```

Nor the watch-compile or server react immediately to changes in the `config.json`. You'll have to restart the processes.

### Start developing

Your code goes inside the `landing/Modules/default/src/` folder. Reference `{[{Tok3n_PlatformHost}]}` instead of `localhost`, `secure.tok3n.com` or  `testinapp.appspot.com`.

For example instead of calling `http://secure.tok3n.com/api/v3/something` you would call `http://{[{Tok3n_PlatformHost}]}/api/v3/something`.

*Don't* compile the dart into js using the DartEditor. Use the `grunt build-prod` command instead.

To see the complete substitutions go to the [Gruntfile](Modules/default/Gruntfile.coffee).

### Compiling for production
Stop any other watch or server terminal window and then:

```sh
grunt build-prod
```