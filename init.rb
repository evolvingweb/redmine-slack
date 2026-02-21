require 'redmine'

# Tell Zeitwerk to ignore this plugin's lib directory
plugin_lib = File.join(File.dirname(__FILE__), 'lib')
Rails.autoloaders.each { |loader| loader.ignore(plugin_lib) }

# Require plugin files
require File.join(plugin_lib, 'redmine_slack/listener')
require File.join(plugin_lib, 'redmine_slack/issue_patch')

Redmine::Plugin.register :redmine_slack do
  name 'Redmine Slack'
  author 'Samuel Cormier-Iijima'
  url 'https://github.com/sciyoshi/redmine-slack'
  author_url 'http://www.sciyoshi.com'
  description 'Slack chat integration'
  version '6.0.0'

  requires_redmine :version_or_higher => '0.8.0'

  settings \
    :default => {
      'callback_url' => 'http://slack.com/callback/',
      'channel' => nil,
      'icon' => 'https://raw.github.com/sciyoshi/redmine-slack/gh-pages/icon.png',
      'username' => 'redmine',
      'display_watchers' => 'no'
    },
    :partial => 'settings/slack_settings'
end

# Apply patch
unless Issue.included_modules.include?(RedmineSlack::IssuePatch)
  Issue.include(RedmineSlack::IssuePatch)
end
