require 'thor'
require 'byebug'

module TGDTemplate

  # Class to look for rbenv and it's installed versions.
  class RVM
    include Thor::Shell

    # Typicall the gemset_name is the same as the app's name
    def initialize(app_name)
      @app_name = app_name
    end # end initialize method

    # def prompt_ruby_version(exit_on_error: true)
    def prompt_ruby_version
      if yes?("Are you using RVM?")
        # rubocop:disable Metrics/LineLength
        if yes?("Would you like to create a RVM gemset, #{@app_name}, for this app?[y|yes] ")
          # rubocop:enable Metrics/LineLength
          template('rvmrc.tt','.rvmrc', {app_name: @app_name})
        else
          puts "Using the default gemset"
          run(". ${rvm_path:-$HOME/.rvm}/environments/default")
        end
      end
    end # end prompt_ruby_version method

  end # end class
end # end module
