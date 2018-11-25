# Jira Issue Details `fastlane` Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-jira_issue_details)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-jira_issue_details`, add it to your project by running:

```bash
fastlane add_plugin jira_issue_details
```

## About This Plugin

Get the details for the given jira issue key.

It utilises the [jira-ruby gem](https://github.com/sumoheavy/jira-ruby) to communicate with Jira and get the details of the Jira issue for the given key. If the key does not exists, it will just return `nil`.

(Currently only supports basic `auth_type` login)

## Actions

### get_jira_issue

Get the jira issue by passing the `username`, `api_token`, `site` and `issue_key` parameters. You can later get the details that you need by accessing the string keys. The reference to all the keys can be found [here](https://developer.atlassian.com/cloud/jira/platform/rest/v3/#api-api-3-issue-issueIdOrKey-get), just scroll to the `responses` section.

Do note that all parameters are required, otherwise the action will return `nil`.

```ruby
issue = get_jira_issue(
  username: 'you@domain.com',
  api_token: 'yourapitoken',
  site: 'https://your-domain.atlassian.net',
  issue_key: 'TCK-123'
)
summary = issue['fields']['summary']
puts summary
#=> Short summary for the ticket id: TCK-123.
```

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
