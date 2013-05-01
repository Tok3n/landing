Requirements
=======
Git
Node.js and npm
Ruby and rubygems
Bundler (gem install bundler)

Installation
=======
git clone http://github.com/Tok3n/landing && cd tok3n
echo "RACK_ENV=development" >> .env
bundle install
npm install

Using locally
=======
This will run the app on localhost:5000 and watch all compass files.
foreman start -f Procfile.dev

Using in production
=======
Be sure to commit your changes before
git push heroku master