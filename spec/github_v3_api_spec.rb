require 'spec_helper'

describe GitHubV3API do
  it 'is initialized with an OAuth2 access token' do
    lambda { GitHubV3API.new('abcde') }.should_not raise_error
  end

  describe '#orgs' do
    it 'returns an instance of GitHubV3API::OrgsAPI' do
      api = GitHubV3API.new('abcde')
      api.orgs.should be_kind_of GitHubV3API::OrgsAPI
    end
  end

  describe '#repos' do
    it 'returns an instance of GitHubV3API::ReposAPI' do
      api = GitHubV3API.new('abcde')
      api.repos.should be_kind_of GitHubV3API::ReposAPI
    end
  end

  describe '#hooks' do
    it 'returns an instance of GitHubV3API:HooksAPI' do
      api = GitHubV3API.new('abcde')
      api.hooks.should be_kind_of GitHubV3API::HooksAPI
    end
  end

  describe "#issues" do
    it "returns an instance of GitHubV3API::IssuesAPI" do
      api = GitHubV3API.new('abcde')
      api.issues.should be_kind_of GitHubV3API::IssuesAPI
    end
  end

  describe '#get' do
    it 'does a get request to the specified path at the GitHub API server and adds the access token' do
      RestClient.should_receive(:get) \
        .with('https://api.github.com/some/path', {:accept => :json, :authorization => 'token abcde', :params => {}}) \
        .and_return('{}')
      api = GitHubV3API.new('abcde')
      api.get('/some/path')
    end

    it 'returns the result of parsing the result body as JSON' do
      RestClient.stub!(:get => "[{\"foo\": \"bar\"}]")
      api = GitHubV3API.new('abcde')
      api.get('/something').should == [{"foo" => "bar"}]
    end

    it 'raises GitHubV3API::Unauthorized instead of RestClient::Unauthorized' do
      RestClient.stub!(:get).and_raise(RestClient::Unauthorized)
      api = GitHubV3API.new('abcde')
      lambda { api.get('/something') }.should raise_error(GitHubV3API::Unauthorized)
    end
  end

  describe "#post" do
    it "does a post request to the specified path at the github server, adds token, and payload as json" do
      data = {:title => 'omgbbq'}
      json = JSON.generate(data)
      RestClient.should_receive(:post) \
        .with('https://api.github.com/some/path', json, {:accept => :json, :authorization => 'token abcde'}) \
        .and_return('{}')
      api = GitHubV3API.new('abcde')
      api.post('/some/path', data)
    end
  end

  describe "#patch" do
    it "does a post request to the specified path at the github server, adds token, and payload as json" do
      data = {:title => 'omgbbq'}
      json = JSON.generate(data)
      RestClient.should_receive(:post) \
        .with('https://api.github.com/some/path', json, {:accept => :json, :authorization => 'token abcde'}) \
        .and_return('{}')
      api = GitHubV3API.new('abcde')
      api.patch('/some/path', data)
    end
  end

  describe "#delete" do
    it 'does a delete request to the specified path at the GitHub API server and adds the access token' do
      RestClient.should_receive(:delete) \
        .with('https://api.github.com/some/path', {:accept => :json, :authorization => 'token abcde'}) \
        .and_return('{}')
      api = GitHubV3API.new('abcde')
      api.delete('/some/path')
    end
  end
end
