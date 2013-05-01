Tok3n Landing Page
=
***
Requirements
-
* [Git][1]
* [Node.js][2]
* [Ruby][3] and [rubygems][4]
* [Bundler][5]

Installation
-

```bash
git clone http://github.com/Tok3n/landing && cd tok3n
echo "RACK_ENV=development" >> .env
bundle install
npm install
```

Using locally
-
This will run the app on localhost:5000 and watch all compass files.
```
foreman start -f Procfile.dev
```

Deploying
-
Remember to configure the following (only if heroku app is new!):
```bash
heroku config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-nodejs
heroku ps:scale web=2
heroku config:set NEW_RELIC_LICENSE_KEY=yourlicensekey
```

To-do
-
* Check when newrelic for node is stable release
* Add https, config dns and stuff
* Do mobile
* Make a/b tests
* Integrate Google Analytics


[1]: http://git-scm.com/downloads
[2]: http://nodejs.org/download/
[3]: http://www.ruby-lang.org/en/downloads/
[4]: http://rubygems.org/pages/download
[5]: http://gembundler.com/