# Rails Application Templates.


This is a Rails template I created for General Assembly's (GA) Web Development Immersive (WDI) course.


To create a new Rails application that will use this template:
rails new <app_name> -m tgd_rails_template.rb

It will: 
* Prompt to create a RVM gemset for the app.
* Use a Gemfile, defined in rails_root/Gemfile
* Use a git ignore file, defined in rails_root/Gemfile
* Prompt to download Bootstrap (In-progress)
* Setup the default rails generators in the app's config/application.rb
* Prompt to download and install Devise
* Setup RSpec for rails.
* Create the config/database.yaml file
* Create a git repo for this application.
* Add all files to this repo and make the first commit.

See the tgd_rails_template.rb for more info.

## References
[Cooking up a Rails Template](http://blog.madebydna.com/all/code/2010/10/11/cooking-up-a-custom-rails3-template.html)
[Rails Application Templates](http://technology.stitchfix.com/blog/2014/01/06/rails-app-templates/)

### Thor Actions
* copy_file(source, *args, &block)
* create_file(destination, *args, &block)
* get(source, *args, &block) -- download files from a remote url
* prepend_file(path, *args, &block)
* remove_file(path, config = {})
* run(command, config = {}) -- used to run bash commands

### Thor User Input
* ask(statement, color = nil) -- Example: "Which design framework? [none(default), compass]: "
* no?(statement, color = nil) -- Returns true if the user has answered the question with no
* yes?(statement, color = nil) -- Returns true if the user has answered the question with yes

### Rails Generator Actions
[Rails Generators Actions](http://api.rubyonrails.org/v4.0.1/classes/Rails/Generators/Actions.html)
* add_source(source, options={}) -- adds a given source to the Gemfile
* gem(*args) -- Adds an entry for the given gem to the Gemfile
* route(routing_code) -- adds a route
* environment(data=nil, options={}, &block) -- insert line into application.rb
* application(data=nil, options={}, &block) -- Alias for environment

### Creating Files
* vendor(filename, data=nil, &block) -- Creates a file in the /vendor directory
* lib(filename, data=nil, &block) -- Creates a file in the /lib directory
* rakefile(filename, data=nil, &block) -- Creates a rakefile in the /lib/tasks directory
* initializer(filename, data=nil, &block) -- Creates a file in the /config/initializers directory

### Executing stuff
* git(command={}) -- Runs a command in git
* generate(what, *args) -- Runs a generator from Rails or a plugin. script/rails generate #{what} [flattened args] is run in the background
* rake(command, options={}) -- Runs the supplied rake task
* readme(path) -- Reads the file at the given path and prints out its contents
* plugin(name, options) -- Installs a plugin from github
