require_relative 'lib/plugin_manager'
PluginManager.load_plugins

Redmine::Plugin.register :plugin_manager do
  name 'Plugin Manager for redmine'
  author 'nodecarter'
  description 'Allow easy select which plugins will be used in redmine for each environment.'
  version '0.0.1'
  url 'https://github.com/Restream/plugin_manager'
  author_url 'https://github.com/nodecarter'
end
