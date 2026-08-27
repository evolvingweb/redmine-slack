require 'redmine'

# Tell Zeitwerk to ignore this plugin's lib directory
# R7: no loader.ignore / manual require — RedmineSlack::Listener (a
# Redmine::Hook::Listener) self-registers and RedmineSlack::IssuePatch autoloads via
# Zeitwerk. NOTE: the listener needs the `httpclient` gem (see the plugin Gemfile);
# 2.9.0+ carries the mutex_m/webrick deps Ruby 3.4 requires. It is only lightly
# maintained upstream (last release Feb 2025) — re-check before any Ruby 4.0 move.
# refs #108530.
Redmine::Plugin.register :redmine_slack do
  name 'Redmine Slack'
  author 'Samuel Cormier-Iijima'
  url 'https://github.com/sciyoshi/redmine-slack'
  author_url 'http://www.sciyoshi.com'
  description 'Slack chat integration'
  version '7.0.0'

  requires_redmine :version_or_higher => '7.0.0'

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
