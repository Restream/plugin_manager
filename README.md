# Plugin Manager for Redmine

**Warning! This plugin is under heavy development and NOT READY FOR PRODUCTION yet.**

This is is plugin manager for redmine.
With this plugin you can easily choose which plugins will be used for each rails environment.
Also you will can add or remove plugins from user interface (now only from config file).

## Installation

1. Copy all your existing plugins to new separate directory:

        cd {REDMINE_ROOT}
        mv plugins plugins_available
        mkdir plugins

    Install plugin manager with git using HTTPS:

        git clone https://github.com/nodecarter/plugin_manager.git plugins/plugin_manager

    or SSH:

        git clone git@github.com:nodecarter/plugin_manager.git plugins/plugin_manager

2. Create configuration file (there will be rake task I think) 'config/plugins.yml':

        production: &production
          - plugin1
          - plugin2
          # ...etc

3. Add following lines to your Gemfile.local. Create if file does not exists yet.

        # Load plugins' Gemfiles
        require_relative 'plugins/plugin_manager/lib/plugin_manager'
        PluginManager.gemfiles.each do | file |
          eval_gemfile file
        end

4. Update you bundle

        bundle install

5. Run you server!

## License

Copyright (c) 2016 Restream

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
