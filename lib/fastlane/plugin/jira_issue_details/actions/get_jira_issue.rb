require 'jira-ruby'
require 'fastlane/action'
require_relative '../helper/jira_issue_details_helper'

module Fastlane
  module Actions
    class GetJiraIssue < Action
      def self.run(params)
        return nil if params[:username].nil? || params[:api_token].nil? || params[:site].nil?

        options = {
          username: params[:username],
          password: params[:api_token],
          context_path: "",
          auth_type: :basic,
          site: "#{params[:site]}:443/",
          rest_base_path: "/rest/api/3"
        }
        client = JIRA::Client.new(options)

        begin
          return client.Issue.find(FastlaneCore::ConfigItem[:issue_key]).attrs
        rescue
          return nil
        end
      end

      def self.description
        "Get the details for the given jira issue key."
      end

      def self.authors
        ["Zaim Ramlan"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "Return a `Hash` containing the details of the jira issue for the given key, or `nil` if the issue key does not exists."
      end

      def self.details
        # Optional:
        "It utilises the `jira-ruby` gem to communicate with Jira and get the details of the Jira issue for the given key.\n\n(Currently only supports basic auth_type login)"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :username,
                                  env_name: "JIRA_ISSUE_DETAILS_USERNAME",
                               description: "Your Jira Username",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :api_token,
                                  env_name: "JIRA_ISSUE_DETAILS_API_TOKEN",
                               description: "Your Jira API Token",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :site,
                                  env_name: "JIRA_ISSUE_DETAILS_SITE",
                               description: "Your Jira Site ('http://yourdomain.atlassian.net')",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :issue_key,
                                  env_name: "JIRA_ISSUE_DETAILS_ISSUE_KEY",
                               description: "Your Jira Issue Key",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
