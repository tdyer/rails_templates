 Generate a rails app using this template
#  rails new <app_name> -m tgd_rails_template.rb

# This depends on gitignore file in the current dir.

# This will create a:
# .rvmrc
# Gemfile with the correct default gems. (Update this as needed)
# Git ingnore file.
# .gitignore
# Foreman setup
# Prompt to download and install Bootstrap
# Setup the default rails generators in config/application.rb
# Prompt to download and install Devise
# Setup Rspec for rails.
# Create the config/database.yaml
# Init and make initial commit


###################################
# Create .rvmrc
###################################
if yes?("Would you like to create a RVM gemset, #{app_name}, for this app?")
  create_file ".rvmrc", <<-RVMFILE
  if [[ -d "\$\{rvm_path:-$HOME/.rvm\}/environments" && \
   -s "\$\{rvm_path:-$HOME/.rvm\}/environments/ruby-2.0.0@#{app_name}" ]] ; then
  \. "\$\{rvm_path:-$HOME/.rvm\}/environments/ruby-2.0.0@#{app_name}"
else
  rvm --create use  "ruby-2.0.0@#{app_name}"
fi
RVMFILE
end

###################################
# Create Gemfile, check this periodically if you update rails
###################################
copy_file 'Gemfile', 'Gemfile_orig'
remove_file 'Gemfile'
create_file 'Gemfile'

add_source 'https://rubygems.org'

# insert_into_file 'Gemfile', "\nruby '2.0.0'", after: "source 'https://rubygems.org'\n"

gem 'rails', '4.0.2'
# remove sqlite3
# gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

gem_group :doc do
  gem 'sdoc', require: false
end

gem 'pg'
gem 'dotenv-rails'
gem 'time_difference'

gem_group :production do
  gem 'rails_12factor'
end

gem_group :development do
  # Add model attributes
  gem 'annotate'

  # help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet. Needs config in development.rb
  gem 'bullet'

  # https://github.com/plentz/lol_dba
  # list columns that should be indexed
  gem 'lol_dba'

  gem 'rails_best_practices', require: false

  # Ruby/CLI: Automatic lossless reduction of all your images
  gem 'smusher'
end


gem_group :test do
  gem 'faker'
  gem 'chronic'
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'guard-rspec', require: false

  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-stack_explorer'

  # Turn off verbose logging of asset requests
  gem 'quiet_assets'

  # see Railscast for better_error gem
  # http://railscasts.com/episodes/402-better-errors-railspanel
  # FOR sublime text 3 MUST INSTALL sublime-url-protocol-mac, http://goo.gl/8KX1lb
  # http://goo.gl/8KX1lb
  gem 'better_errors'
  gem 'binding_of_caller'

  # Show a rails panel in Chrome. Requires a Chrome extension.
  # https://github.com/dejan/rails_panel
  gem 'meta_request'
end

###################################
# Create git ignore file.
###################################
copy_file "~/TomRepo/gitignore", '.gitignore'


###################################
# Create foreman, for heroku deploy
###################################

# Setting up foreman to deal with environment variables and services
# https://github.com/ddollar/foreman
# ==================================================
# Use Procfile for foreman

# run "echo 'web: bundle exec rails server -p $PORT' >> Procfile"
# run "echo PORT=3000 >> .env"
# run "echo '.env' >> .gitignore"
# # We need this with foreman to see log output immediately
# run "echo 'STDOUT.sync = true' >> config/environments/development.rb"



###################################
# Set the application generators
###################################
application do
  <<-APPCONFIG
     # Customize generators config.generators
     config.generators do |g|
       # g.stylesheets false
       # g.assets false
       g.controller_specs false
       g.view_specs false
       g.test_framework :rspec
       # g.form_builder :simple_form
       # g.fixture_replacement :factory_girl, :dir => 'spec/factories'
     end
  APPCONFIG
end


# inject_into_file 'config/application.rb', :after => "class Application < Rails::Application" do
#   <<-APPCONFIG
#      # Customize generators config.generators
#      config.generators do |g|     do |g|
#        # g.stylesheets false
#        # g.assets false
#        g.controller_specs false
#        g.view_specs false
#        g.test_framework :rspec
#        # g.form_builder :simple_form
#        # g.fixture_replacement :factory_girl, :dir => 'spec/factories'
#      end
#   APPCONFIG
# end

###################################
# Remove turbolinks stuff
###################################
puts "Removing Turbolinks"
gsub_file 'app/assets/javascripts/application.js', /\/\/=\ require turbolinks/, ''
# TODO: fix this
#gsub_file 'app/views/layouts/application.html.erb', /\,\s+["|']data-turbolinks-track["|']\.*\%\>/, ''

###################################
# Setup and init RSpec
###################################
run "echo '--format documentation' >> .rspec"
run "rspec --init"

###################################
# Create database.yml
###################################
remove_file 'config/database.yml'
create_file 'config/database.yml' do
  <<-YAML
defaults: &defaults
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *defaults
  database: #{app_name}_development

test:
  <<: *defaults
  database: #{app_name}_test

production:
  <<: *defaults
  database: #{app_name}_production
YAML
end

###################################
# Install Bootstrap?
###################################
#  Bootstrap: install from https://github.com/twbs/bootstrap
# Note: This is 3.0.0
# ==================================================
if yes?("Download bootstrap?")
  run "wget https://github.com/twbs/bootstrap/archive/v3.0.0.zip -O bootstrap.zip -O bootstrap.zip"
  run "unzip bootstrap.zip -d bootstrap && rm bootstrap.zip"
  run "cp bootstrap/bootstrap-3.0.0/dist/css/bootstrap.css vendor/assets/stylesheets/"
  run "cp bootstrap/bootstrap-3.0.0/dist/js/bootstrap.js vendor/assets/javascripts/"
  run "rm -rf bootstrap"
  run "echo '@import \"bootstrap\";' >>  app/assets/stylesheets/application.css.scss"
  run "rails g simple_form:install --bootstrap"
end

###################################
# Install Devise?
###################################
if yes?("Would you like to install Devise?")
  gem "devise"
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
end

###################################
# Init and make initial commit
###################################

git :init
git add: "."
git commit: %Q{ -m "Initial commit"}
