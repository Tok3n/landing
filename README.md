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


[1]: http://git-scm.com/downloads
[2]: http://nodejs.org/download/
[3]: http://www.ruby-lang.org/en/downloads/
[4]: http://rubygems.org/pages/download
[5]: http://gembundler.com/