# Loading routes from enabled plugins

PluginManager.plugins.each do |plugin|
  file = File.join(PluginManager::PLUGINS_AVAILABLE_DIR, plugin, 'config', 'routes.rb')
  if File.exists?(file)
    begin
      instance_eval File.read(file)
    rescue Exception => e
      puts "An error occurred while loading the routes definition of #{plugin} plugin (#{file}): #{e.message}."
      exit 1
    end
  end
end
