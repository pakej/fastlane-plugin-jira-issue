# Jira Issue Details `fastlane` Plugin [![Build Status](https://app.bitrise.io/app/72df6f31dbaba55c/status.svg?token=eNywJtIKO1opSsI9PbEHVQ&branch=develop)](https://app.bitrise.io/app/72df6f31dbaba55c)

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-jira_issue_details) [![Gem Version](https://badge.fury.io/rb/fastlane-plugin-jira_issue_details.svg)](https://badge.fury.io/rb/fastlane-plugin-jira_issue_details)

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

1. Passing a single jira `issue_key`
    
    In return, you'll get a single hash, or `nil` if the issue for the given key was not found.

    ```ruby
    issue = get_jira_issue(
      username: 'you@domain.com',
      api_token: 'yourapitoken',
      site: 'https://your-domain.atlassian.net',
      issue_key: 'TKT-123'
    )

    summary = issue['fields']['summary']
    puts summary
    #=> Short summary for the ticket id TKT-123
    ```

1. Passing multiple jira `issue_key`s (Do note that you should **only** separate the keys using a single space ` `)

    In return, you'll get a hash of `key-hash` pair, or `key-nil` pair if the issue was not found.

    ```ruby
    issue = get_jira_issue(
      username: 'you@domain.com',
      api_token: 'yourapitoken',
      site: 'https://your-domain.atlassian.net',
      issue_key: 'TKT-123 TKT-456'
    )

    summary = issue['TKT-123']['fields']['summary']
    puts summary
    #=> Short summary for the ticket id: TKT-123

    # assuming TKT-456 doesn't exist
    summary = issue['TKT-456']
    puts summary
    #=> nil
    ```    

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
