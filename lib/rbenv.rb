require 'thor'
require 'byebug'

module TGDTemplate

  # Class to look for rbenv and it's installed versions.
  class RBENV
    include Thor::Shell

    attr_reader :installed, :version, :rubies

    def initialize(rbenv_root: '~/.rbenv')
      # Look for the top/root directory for rbenv in the HOME directory
      @installed = Dir.exist?(File.expand_path(rbenv_root))
    end

    def prompt_ruby_version(exit_on_error: true)
      if @installed
        # rbenv is installed
        # Prompt for which of the installed ruby version to use.
        @version = ask('Which version of Ruby do you want to use?',
                       limited_to: installed_rubies)
      else
        # couldn't file the $HOME/.rbenv dir, rbenv is NOT installed
        say "Looks like you haven't installed rbenv?", :red
        say 'Install from https://github.com/rbenv/rbenv and come back!', :red
        # quit program
        exit if exit_on_error
      end
    end

    private

    def installed_rubies
      # find all the rbenv installed rubies
      @rubies = %x{ ls $RBENV_ROOT/versions }.split("\n")
    end
  end
end
