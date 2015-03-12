#  Generate a rails app using this template
puts "Generating a Rails application with Tom's rails template"

#  rails new <app_name> -m  ~/TomRepo/rails_templates/tgd_rails_template.rb

# This depends on the .gitignore file in the current dir.

# This will prompt to create a RVM gemset with a .rvmrc file:
# Gemfile with the correct default gems. (Update this as needed)
# Git ignore file, .gitignore
# Foreman setup (Not yet implemented)
# Prompt to download and install Bootstrap (Not yet implemented)
# Setup the default rails generators in config/application.rb
# Prompt to download and install Devise
# Setup Rspec for rails.
# Create the config/database.yaml
# Init and make initial commit

# The absolute path to this dir
$LOCAL_PATH = File.dirname(File.realpath(__FILE__))
puts "$LOCAL_PATH is #{$LOCAL_PATH}"

# The absolute path to the rails_root dir
$RR_PATH = File.join($LOCAL_PATH,'rails_root')
puts "$RR_PATH is #{$LOCAL_PATH}"

# This method will be called when looking for files that should be
# copied, moved, etc in to the new rails app. It will determine where
# to find those files.
def source_paths
  puts "Getting the source paths"
  [$RR_PATH] + Array(super)
end

# Add the rails_root dir to the Ruby LOAD PATH
$LOAD_PATH.unshift($RR_PATH)
puts "Set the Ruby load path #{$LOAD_PATH}"

###################################
# Use ./railsrc for rails new --help options
###################################
puts 'Setting the .railsrc'
copy_file '.railsrc'

###################################
# Create .rvmrc
###################################
if yes?("Would you like to create a RVM gemset, #{app_name}, for this app?[y|yes] ")
  template('rvmrc.tt','.rvmrc', {app_name: app_name})
else
  puts "Using the default gemset"
  run(". ${rvm_path:-$HOME/.rvm}/environments/default")
end

###################################
# Update the Gemfile
###################################
puts 'Setting the Gemfile'
insert_into_file 'Gemfile', "\nruby '2.2.0'", after: "source 'https://rubygems.org'\n"

gem 'pg'
gem 'newrelic_rpm'
gem 'rack-cors'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'nokogiri'
gem 'time_difference'

# add gems for dev & test env
gem_group :development, :test do
  gem 'capybara'
  gem 'rubocop'
  gem 'bullet'
  gem 'lol_dba'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'codeclimate-test-reporter', require: nil
  gem 'annotate'
  gem 'rails_best_practices'
  gem 'chronic'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'rspec-its'
end

gem_group :development do
  gem 'guard'
  gem 'guard-rails'
end

# add gems for production env
gem_group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'rails_stdout_logging'
  gem 'rails_serve_static_assets'
end

# Remove comments
gsub_file 'Gemfile', /[#].*/,''
# Remove duplicate newlines
gsub_file 'Gemfile', /[\n]+/,"\n"

# remote sqlite
gsub_file 'Gemfile', /gem \'sqlite3\'/, ''

###################################
# Use ./gitignore in this rails app.
###################################
puts 'Setting the .gitignore'
remove_file '.gitignore'
copy_file '.gitignore'

###################################
# Create foreman, for heroku deploy
###################################
# puts 'Setting up foreman'
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

###################################
# Remove turbolinks from javascript manifest file
###################################
inside 'app' do
  inside 'assets' do
    inside 'javascripts' do
      remove_file 'application.js'
      template('application.js.tt', 'application.js')
    end
  end
end

###################################
# Remove turbolinks from layout and add flash handling
###################################
inside 'app' do
  inside 'views' do
    inside 'layouts' do
      remove_file 'application.html.erb'
      template('application.html.erb.tt', 'application.html.erb', { app_name: app_name})
    end
  end
end

###################################
# Setup and init RSpec
###################################
run "echo '--format documentation' >> .rspec"
run "rspec --init"

###################################
# Create database.yml
###################################
inside 'config' do
  remove_file('database.yml')
  template('database.yml.tt', 'database.yml', { app_name: app_name})
end

###################################
# Install Bootstrap?
###################################
#  Bootstrap: install from https://github.com/twbs/bootstrap
# Note: This is 3.0.0
# ==================================================
if yes?("Download bootstrap?[y|yes] ")
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
if yes?("Would you like to install Devise?[y|yes] ")
  gem "devise"
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
end

###################################
# Bundle Install
###################################
run 'bundle install'

###################################
# Init the DB
###################################
rake("db:drop")
rake("db:create")
rake("db:migrate")

###################################
# Init and make initial commit
###################################
git :init
git add: "."
git commit: %Q{ -m "Initial commit"}

###################################
# Create a remote repository.
# NOTE: you MUST have a github api key in the api_keys.rb file
###################################
if yes?("Create a repository, \"#{app_name}\", in for this app?[y|yes] ")
  # require 'dotenv'
  # Dotenv.load

  API_FILE = 'api_keys.rb'

  # Load the file, github_api_key.rb, that contains the github api key.
  # MAKE SURE YOU GIT IGNORE THIS FILE!!
  load "#{File.join(File.expand_path(File.dirname(__FILE__)), API_FILE)}"
  github_api_key = GITHUB_ACCESS_TOKEN
  raise "Missing github api key" if github_api_key.nil? || github_api_key.empty?

  require 'octokit'
  client = Octokit::Client.new(access_token: github_api_key)
  user = client.user

  github_account_url =  "https://github.com/#{user.login}"
  repo_url = "#{github_account_url}/#{app_name}"
  puts "Adding repository #{app_name} to #{github_account_url}"

  if client.create_repository(app_name, :private => false)
    puts "Created Repository #{repo_url}"
  else
    puts "Error: Creating Repository #{repo_url}"
  end

  # add remote reference to this new repo
  git remote: %Q( add origin git@github.com:#{user.login}/#{app_name}.git )

  # sync with remote
  git push: %Q{ -u origin master }

  puts "Pushed to remote repository"

  %x( open "https://github.com/#{user.login}/#{app_name}" )
end


puts "DONE "
