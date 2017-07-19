require_relative 'lib/plugin_manager'

PluginManager.load_plugins

# Hack for loading deface overrides
Deface::Railtie.activate if defined?(Deface)

Redmine::Plugin.register :plugin_manager do
  name 'Plugin Manager for redmine'
  author 'nodecarter'
  description 'Allow easy select which plugins will be used in redmine for each environment.'
  version '0.0.3'
  url 'https://github.com/Restream/plugin_manager'
  author_url 'https://github.com/nodecarter'
end
