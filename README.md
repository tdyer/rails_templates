# Rails Application Templates.


This is a Rails template I created for General Assembly's (GA) Web Development Immersive (WDI) course.


To create a new Rails application that will use this template:

```bash
rails new <app_name> -m ~/TomRepo/rails_templates/tgd_rails_template.rb 
```

It will:

* Prompt the user to create a RVM gemset for the app.
* Use a Gemfile, defined in rails_root/Gemfile
* Use a git ignore file, defined in rails_root/Gemfile
* Prompt to download Bootstrap (In-progress)
* Setup the default rails generators in the app's config/application.rb
* Prompt to download and install Devise
* Setup RSpec for rails.
* Create the config/database.yaml file
* Create a git repo for this application.
* Add all files to this repo and make the first commit.

See the `tgd_rails_template.rb` and the below documentation for more info on Rails Templates.



### Thor Actions

Inside of our template file we have access to Thor and it's [actions](http://www.rubydoc.info/github/wycats/thor/master/Thor/Actions). Here's a couple of Thor actions.

* [copy_file(source, *args, &block)](http://www.rubydoc.info/github/wycats/thor/Thor%2FActions%3Acopy_file) - copy file from a src to a dest.

	```ruby
	copy "README" "doc/README"
	```
* [create_file(destination, *args, &block)](http://www.rubydoc.info/github/wycats/thor/Thor/Actions#create_file-instance_method) - create a new file with content.

	```ruby
	create_file "lib/fun_party.rb" do
  hostname = ask("What is the virtual hostname I should use?")
  "vhost.name = #{hostname}"
end
  ``` 
* [get(source, *args, &block)](http://www.rubydoc.info/github/wycats/thor/Thor/Actions#get-instance_method) -- download files from a remote url save as a local file.

	```ruby
	get "http://gist.github.com/103208", "doc/README"
	```
* [prepend_file(path, *args, &block)](http://www.rubydoc.info/github/wycats/thor/Thor/Actions#prepend_to_file-instance_method) - Prepend text to a file.

	```ruby
	prepend_to_file 'config/environments/test.rb' do
  'config.gem "rspec"'
end
	```
* [remove_file(path, config = {})](http://www.rubydoc.info/github/wycats/thor/Thor/Actions#remove_file-instance_method) - Remove a file.

	```ruby
	remove_file 'app/controllers/application_controller.rb'
	```
* [run(command, config = {})](http://www.rubydoc.info/github/wycats/thor/Thor/Actions#run-instance_method) - Executes a command returning the contents of the command.
	
	```ruby
	inside('vendor') do
  	  run('ln -s ~/edge rails')
	end
	```

### Thor User Input

We can use a couple of [Thor::Shell::Basic](http://www.rubydoc.info/github/wycats/thor/master/Thor/Shell/Basic) instance methods to get user input when our template is executed. For example:

* [ask(statement, color = nil)](http://www.rubydoc.info/github/wycats/thor/master/Thor/Shell/Basic#ask-instance_method) - As a question, "Which design framework? [none(default), compass]: "

	```ruby
	model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
	```
	
	```ruby
	ask(“What is your name?”)

	ask(“What is your favorite Neopolitan flavor?”, :limited_to => [“strawberry”, “chocolate”, “vanilla”])

	ask(“What is your password?”, :echo => false)

	ask(“Where should the file be saved?”, :path => true)
	```
	
* [no?(statement, color = nil)](http://www.rubydoc.info/github/wycats/thor/master/Thor/Shell/Basic#no%3F-instance_method) - Returns true if the user has answered the question with no.
* [yes?(statement, color = nil)](http://www.rubydoc.info/github/wycats/thor/master/Thor/Shell/Basic#yes%3F-instance_method) - Returns true if the user has answered the question with yes.

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

## References
* [Thor - Railscasts](http://railscasts.com/episodes/242-thor?view=asciicast)
* [Thor - Homepage](http://whatisthor.com/)
* [Thor - Methods](http://www.rubydoc.info/github/wycats/thor)
* [Rails Application Templates - Rails Guide](http://guides.rubyonrails.org/rails_application_templates.html)
* [Cooking up a Rails Template](http://blog.madebydna.com/all/code/2010/10/11/cooking-up-a-custom-rails3-template.html)
* [Rails Application Templates](http://technology.stitchfix.com/blog/2014/01/06/rails-app-templates/)
