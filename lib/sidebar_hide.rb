require "sidebar_hide/version"

module SidebarHide
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path('../init', __dir__)

      # mirror assets files to redmine_root/public/plugin_assets
      plugin = Redmine::Plugin.find('sidebar_hide')
      plugin.directory(File.expand_path('../', __dir__))
      plugin.mirror_assets

      create_hint = true
      # TODO: support Redmine 3.5.0
      plugins_dir = File.join(Bundler.root, 'plugins')
      Dir.glob(File.join(plugins_dir, '*/sidebar_hide.gemspec')) do |gemspec_path|
        Rails.logger.warn('Skip to load sidebar_hide plugin installed as gem.')
        Rails.logger.warn('Use plugins directory\'s sidebar_hide plugin')
        create_hint = false
      end

      if create_hint
        # Create text file to Redmine's plugins directory.
        # The purpose is telling plugins directory to users.
        path = File.join(plugins_dir, 'sidebar_hide')
        if !File.exists?(path)
          File.open(path, 'w') do |f|
            f.write(<<EOS)
This plugin was installed as gem wrote to Gemfile.local instead of putting Redmine's plugin directory.
See sidebar_hide gem installed directory.
EOS
          end
        end
      end
    end
  end
end
