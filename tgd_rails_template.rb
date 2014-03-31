#  Generate a rails app using this template

#  rails new <app_name> -m tgd_rails_template.rb

# This depends on gitignore file in the current dir.

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

# Add this current directory and the the rails_root dir to the
# beginning of of the path that will be searched for files.
def source_paths
#     [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')] +
    [File.join(File.expand_path(File.dirname(__FILE__)),'.')] +
    Array(super)
  # Array(super) will be rvm dir for app templates, .rvm/gems/ruby-2.0.0-p353/gems/railties-4.0.3/lib/rails/generators/rails/app/templates
end

###################################
# Create .rvmrc
###################################
if yes?("Would you like to create a RVM gemset, #{app_name}, for this app?")
  template('./rvmrc.tt','./.rvmrc', {app_name: app_name})
else
  puts "Using the default gemset"
  run(". ${rvm_path:-$HOME/.rvm}/environments/default")
end

###################################
# Use ./Gemfile, check this periodically if you update rails and gems
###################################
remove_file 'Gemfile'
copy_file 'Gemfile'

###################################
# Use ./gitignore in this rails app.
###################################
remove_file '.gitignore'
copy_file '.gitignore'

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
# Remove turbolinks from layout, add flash
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
