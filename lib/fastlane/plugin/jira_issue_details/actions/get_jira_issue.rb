require 'jira-ruby'
require 'fastlane/action'
require_relative '../helper/jira_issue_details_helper'

module Fastlane
  module Actions
    class GetJiraIssueAction < Action
      def self.run(params)
        input = get_input_from_env
        input = get_input_from(params) if is_exists?(params)
        return nil if is_nil_any(input)

        client = JIRA::Client.new(options_for_jira_client(input))
        return get_issues_from(client, input)
      end

      def self.description
        "Get the details for the given jira issue key."
      end

      def self.authors
        ["Zaim Ramlan"]
      end

      def self.return_value
        "Return a `Hash` containing the details of the jira issue for the given key, or `nil` if the issue key does not exists."
      end

      def self.details
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

      private 

      def self.get_input_from_env
        {
          site: ENV['JIRA_ISSUE_DETAILS_SITE'],
          username: ENV['JIRA_ISSUE_DETAILS_USERNAME'],
          api_token: ENV['JIRA_ISSUE_DETAILS_API_TOKEN'],
          issue_key: ENV['JIRA_ISSUE_DETAILS_ISSUE_KEY']
        }
      end

      def self.is_exists?(params)
        params && params[:site] && params[:username] && params[:api_token] && params[:issue_key]        
      end

      def self.get_input_from(params)
        {
          site: params[:site],
          username: params[:username],
          api_token: params[:api_token],
          issue_key: params[:issue_key]
        }
      end

      def self.is_nil_any(input)
        input[:site].nil? || input[:username].nil? || input[:api_token].nil? || input[:issue_key].nil?
      end

      def self.options_for_jira_client(input)
        {
          username: input[:username],
          password: input[:api_token],
          context_path: "",
          auth_type: :basic,
          site: "#{input[:site]}:443/",
          rest_base_path: "/rest/api/3"
        }
      end

      def self.get_issues_from(client, input)
        issues = []
        keys = input[:issue_key].split(" ")
        keys.each {|key| issues.push(fetch_issue(key, client)).reject!(&:nil?) }
        
        return issues.first if keys.count == 1
        return issues
      end

      def self.fetch_issue(key, client)
        begin
          return client.Issue.find(key).attrs
        rescue
          return nil
        end        
      end
    end
  end
end
