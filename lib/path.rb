module TGDTemplate
  # Setup paths for the template script
  class Path
    extend Thor::Shell
    class << self
      def setup_paths(verbose: false)
        # The absolute path to this repo's root directory
        local_path = File.dirname(File.expand_path('..', __FILE__))
        say "local_path is #{local_path}", :magenta if verbose

        # $RR_PATH - Absolute path to the directory that holds files to be added
        # to the new generated rails app,'<repo>/rails_root'
        $RR_PATH = File.join(local_path, 'rails_root')
        say "$RR_PATH is #{$RR_PATH}", :magenta if verbose
        $LOAD_PATH.unshift($RR_PATH) # add to the front of the Ruby load path.
        say "Ruby load path is #{$LOAD_PATH}", :magenta if verbose

        # $APP_FULLPATH - Absolute path to the project directory of the new
        # rails app being generated.
        $APP_FULLPATH = Dir.pwd
        say "$APP_FULLPATH is #{$APP_FULLPATH}", :magenta if verbose

        add_binstubs
        show_path_var if verbose
      end

      def show_path_var
        say "$PATH is #{ENV['PATH']}", :magenta
      end

      # Add './bin' to the $PATH env variable. Need this to run the binstubs
      # in the generated new app's bin directory
      def add_binstubs
        ENV['PATH'] = "./bin:#{ENV['PATH']}"
      end
    end
  end
end
