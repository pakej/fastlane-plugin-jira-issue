require 'webmock/rspec'

describe Fastlane::Actions::GetJiraIssueAction do
  describe 'get_jira_issue' do
    context 'when site, username, api_token and issue_key are defined' do
      let(:stub_method) { return :get }
      let(:stub_url) { return "#{ENV['JIRA_ISSUE_DETAILS_SITE']}/rest/api/3/issue/#{jira_issue_details['id']}" }
      let(:stub_headers) { return {headers:{'Accept'=>'application/json','Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3','Authorization'=>'Basic dXNlckBtb2NrZWQuY29tOm1vY2tlZGFwaXRva2Vu','User-Agent'=>'Ruby'}} }
      let(:stub_response) { return {status: 200, body: '', headers: {}} }
      let(:jira_issue_details) { return {'id' => ENV['JIRA_ISSUE_DETAILS_ISSUE_KEY']} }

      before :context do
        ENV['JIRA_ISSUE_DETAILS_SITE'] = 'https://mocked.atlassian.net'
        ENV['JIRA_ISSUE_DETAILS_USERNAME'] = 'user@mocked.com'
        ENV['JIRA_ISSUE_DETAILS_API_TOKEN'] = 'mockedapitoken'
        ENV['JIRA_ISSUE_DETAILS_ISSUE_KEY'] = 'mocked-123'
      end

      after :context do
        ENV.delete('JIRA_ISSUE_DETAILS_SITE')
        ENV.delete('JIRA_ISSUE_DETAILS_USERNAME')
        ENV.delete('JIRA_ISSUE_DETAILS_API_TOKEN')
        ENV.delete('JIRA_ISSUE_DETAILS_ISSUE_KEY')
      end

      context 'as action parameters' do
        let(:jira_issue_details) { return {'id' => 'params-123'} }

        it 'returns a hash containing the jira issue details based on the parameters' do
          stub_request(stub_method, stub_url).with(stub_headers).to_return(stub_response)

          params = {
            site: ENV['JIRA_ISSUE_DETAILS_SITE'],
            username: ENV['JIRA_ISSUE_DETAILS_USERNAME'],
            api_token: ENV['JIRA_ISSUE_DETAILS_API_TOKEN'],
            issue_key: jira_issue_details['id']
          }
          result = Fastlane::Actions::GetJiraIssueAction.run(params)
          
          expect(result).to eq(jira_issue_details)
        end
      end

      context 'as ENV variables' do
        it 'returns a hash containing the jira issue details based on the ENV variables' do
          stub_request(stub_method, stub_url).with(stub_headers).to_return(stub_response)
          result = Fastlane::Actions::GetJiraIssueAction.run(nil)
          expect(result).to eq(jira_issue_details)
        end
      end      
    end

    context 'when username, api_token and site are not defined' do
      it 'should return nil' do
        result = Fastlane::Actions::GetJiraIssueAction.run(nil)
        expect(result).to be_nil
      end
    end
  end
end
