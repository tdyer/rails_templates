module TGDTemplate

  # Setup paths for the template script
  class Path
    extend Thor::Shell

    class << self

      # $RR_PATH - Absolute path to the directory that holds files to be added
      # to the new rails app. './rails_root' by the app template.
      # $APP_FULLPATH - Absolute path to the directory that holds files to
      # be added to the new, generated, rails app.
      # Add the $RR_PATH to the Ruby load path.
      # Add './bin' to the $PATH env variable. Need this to run the binstubs
      # in the generated new app's bin directory
      def set_paths(verbose: false)
        # The absolute path to this dir
        local_path = File.dirname(File.expand_path("..", __FILE__))
        say "local_path is #{local_path}", :magenta

        # The absolute path to the ./rails_root dir
        $RR_PATH = File.join(local_path,'rails_root')
        say  "$RR_PATH is #{$RR_PATH}", :magenta unless verbose

        # Add the ./rails_root dir to the Ruby LOAD PATH
        $LOAD_PATH.unshift($RR_PATH)
        say "Ruby load path is #{$LOAD_PATH}", :magenta unless verbose

        # The absolute path to the rails_root dir for the
        # generated application.
        $APP_FULLPATH = Dir.pwd
        say"$APP_FULLPATH is #{$APP_FULLPATH}", :magenta unless verbose

        self.add_binstubs
        self.show_path_var unless verbose
      end

      def show_path_var
        say  "$PATH is #{ENV["PATH"]}", :magenta
      end

      # Add './bin' to the $PATH env variable. Need this to run the binstubs
      # in the generated new app's bin directory
      def add_binstubs
        ENV["PATH"] = "./bin:#{ENV['PATH']}"
      end
    end
  end
end
