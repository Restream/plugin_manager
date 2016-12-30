require 'yaml'
require 'bundler'

class PluginManager
  PLUGINS_AVAILABLE_DIR = File.expand_path('../../../../plugins_available', __FILE__)
  PLUGINS_CONFIG_FILE   = File.expand_path('../../../../config/plugins.yml', __FILE__)

  # Define singleton methods for simplicity
  class << self
    %w(load_plugins plugins load_rake_tasks gemfiles plugins_path_pattern).each do |cmethod|
      define_method cmethod do |*args|
        instance = self.new
        instance.send cmethod, *args
      end
    end
  end

  ##
  # Load all currently selected plugins.
  #
  def load_plugins

    # Change directory for plugins
    Redmine::Plugin.directory = PLUGINS_AVAILABLE_DIR

    # Load only plugins listed in plugins.yml for current environment
    plugins.each do |plugin_id|
      load_plugin plugin_id
    end
  end

  ##
  # Load rake tasks from currently selected plugins.
  #
  def load_rake_tasks
    plugins.each do |plugin_id|
      rake_tasks_glob = File.join(PLUGINS_AVAILABLE_DIR, plugin_id, 'lib/tasks/**/*.rake')
      Dir[rake_tasks_glob].sort.each { |plugin_rake_task| load plugin_rake_task }
    end
  end

  ##
  # Returns gemfiles paths of all available plugins.
  # @return [ Array<String> ]
  #
  def gemfiles
    gemfiles = []
    available_plugins.each do |plugin_id|
      gemfiles_glob = File.join(PLUGINS_AVAILABLE_DIR, plugin_id, '{Gemfile,PluginGemfile}')
      gemfiles      += Dir[gemfiles_glob]
    end
    gemfiles
  end

  ##
  # Returns array of currently selected plugin ids.
  # @return [Array<String>] plugin ids
  #
  def plugins
    @@plugins ||= begin
      if no_plugins?
        puts '*** Plugins disabled with NO_PLUGINS variable ***'
        []
      else
        get_plugin_names_for_env get_env
      end
    end
  end

  ##
  # Returns pattern for file globbings with enabled plugin names
  # Example output:
  #   plugins_available/(plugin_foo|plugin_bar)
  #
  # @param [String] exact_plugin: Optional. Fill plugin name if pattern should be build for one plugin.
  # @return [String]
  #
  def plugins_path_pattern(exact_plugin = nil)
    pattern = plugins.join('|')
    pattern = "(#{pattern})" if plugins.many?
    "#{PLUGINS_AVAILABLE_DIR}/#{exact_plugin || pattern}"
  end

  private

  ##
  # Load plugin into redmine.
  # @param [ String ] plugin_id plugin name (should be the same as id)
  #
  def load_plugin(plugin_id)
    directory = File.join(PLUGINS_AVAILABLE_DIR, plugin_id)

    if File.directory?(directory)
      lib = File.join(directory, 'lib')
      if File.directory?(lib)
        $:.unshift lib
        ActiveSupport::Dependencies.autoload_paths += [lib]
      end
      initializer = File.join(directory, 'init.rb')
      if File.file?(initializer)
        require initializer
      end
    end
  end

  ##
  # Return current environment name. Default - 'development'
  # @return [ String ]
  #
  def get_env
    ENV['RAILS_ENV'] || 'development'
  end

  ##
  # Test environment variables for NO_PLUGINS variable.
  # With this variable you can temporary disable all plugins.
  #
  def no_plugins?
    ENV['NO_PLUGINS']
  end

  ##
  # Read all plugin names for target env from config file.
  # @param [ String ]         env environment name
  # @return [ Array<String> ] plugin names
  #
  def get_plugin_names_for_env(env)
    config = YAML.load_file(PLUGINS_CONFIG_FILE)
    return [] if config[env].nil?
    config[env].flatten.compact.uniq
  rescue Errno::ENOENT
    puts "Not found plugins config #{ PLUGINS_CONFIG_FILE }. Will be used all available plugins."
    available_plugins
  end

  ##
  # Returns all available plugins.
  # @return [ Array<String> ] plugin names
  #
  def available_plugins
    list = []
    Dir[File.join(PLUGINS_AVAILABLE_DIR, '*')].each do |plugin_dir|
      list << File.basename(plugin_dir) if File.directory?(plugin_dir)
    end
    list
  end

end
