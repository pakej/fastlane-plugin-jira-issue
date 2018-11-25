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

      context 'with a single jira issue key' do
        context 'as action parameters' do
          let(:jira_issue_details) { return {'id' => 'params-123'} }

          it 'returns a hash containing the details of the given jira issue key in the parameters' do
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
          it 'returns a hash containing the details of the given jira issue key in the ENV variables' do
            stub_request(stub_method, stub_url).with(stub_headers).to_return(stub_response)
            result = Fastlane::Actions::GetJiraIssueAction.run(nil)
            expect(result).to eq(jira_issue_details)
          end          
        end        
      end

      context 'with multiple jira issue keys' do
        let(:jira_issue_details_array) { return [{'id' => 'params-123'}, {'id' => 'params-456'}] }
        let(:stub_urls) do
          return [
            "#{ENV['JIRA_ISSUE_DETAILS_SITE']}/rest/api/3/issue/#{jira_issue_details_array[0]['id']}",
            "#{ENV['JIRA_ISSUE_DETAILS_SITE']}/rest/api/3/issue/#{jira_issue_details_array[1]['id']}"
          ]
        end

        context 'as action parameters' do
          it 'returns an array of hashes containing the details of the given multiple jira issue keys in the parameters' do
            stub_request(stub_method, stub_urls[0]).with(stub_headers).to_return(stub_response)
            stub_request(stub_method, stub_urls[1]).with(stub_headers).to_return(stub_response)

            params = {
              site: ENV['JIRA_ISSUE_DETAILS_SITE'],
              username: ENV['JIRA_ISSUE_DETAILS_USERNAME'],
              api_token: ENV['JIRA_ISSUE_DETAILS_API_TOKEN'],
              issue_key: "#{jira_issue_details_array[0]['id']} #{jira_issue_details_array[1]['id']}"
            }          
            result = Fastlane::Actions::GetJiraIssueAction.run(params)

            expect(result).to eq(jira_issue_details_array)
          end
        end
        
        context 'as ENV variables' do
          it 'returns an array of hashes containing the details of the given multiple jira issue keys in the parameters' do
            stub_request(stub_method, stub_urls[0]).with(stub_headers).to_return(stub_response)
            stub_request(stub_method, stub_urls[1]).with(stub_headers).to_return(stub_response)
            ENV['JIRA_ISSUE_DETAILS_ISSUE_KEY'] = "#{jira_issue_details_array[0]['id']} #{jira_issue_details_array[1]['id']}"

            result = Fastlane::Actions::GetJiraIssueAction.run(nil)
            expect(result).to eq(jira_issue_details_array)
          end          
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
