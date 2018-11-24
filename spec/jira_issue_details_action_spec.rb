describe Fastlane::Actions::JiraIssueDetailsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The jira_issue_details plugin is working!")

      Fastlane::Actions::JiraIssueDetailsAction.run(nil)
    end
  end
end
