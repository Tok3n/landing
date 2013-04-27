require 'sassy-buttons'
require 'ninesixty'
require 'compass_twitter_bootstrap'

# General
environment = 'development'
output_style = (environment == :production) ? :compressed : :expanded
relative_assets = true
preferred_syntax = :sass
Sass::Script::Number.precision = 2

# Sass Paths
http_path = '/'
http_javascripts_path = http_path + 'js/'
http_stylesheets_path = http_path + 'css/'
http_images_path = http_stylesheets_path + 'img/'
http_fonts_path = http_stylesheets_path + 'fonts/'
 
# Sass Directories
javascripts_dir = 'js/'
css_dir = 'css/'
sass_dir = 'sass/'
images_dir = css_dir + 'img/'
fonts_dir = css_dir + 'fonts/'
