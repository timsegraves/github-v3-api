require 'spec_helper'

describe GitHubV3API::HooksAPI do
  describe '#list' do
    it 'returns all hooks for a given repo' do
      connection = mock(GitHubV3API)
      connection.should_receive(:get).with('/repos/octocat/hello-world/hooks').and_return([:hook_hash1, :hook_hash2])
      api = GitHubV3API::HooksAPI.new(connection)
      GitHubV3API::Hook.should_receive(:new).with(api, :hook_hash1).and_return(:hook1)
      GitHubV3API::Hook.should_receive(:new).with(api, :hook_hash2).and_return(:hook2)
      hooks = api.list('octocat', 'hello-world')
      hooks.should == [:hook1, :hook2]
    end
  end

  describe '#get' do
    it 'returns a fully-hydrated Hook object for the specified user and repo name' do
      connection = mock(GitHubV3API)
      connection.should_receive(:get).with('/repos/octocat/hello-world/hooks/hook-id').and_return(:hook_hash)
      api = GitHubV3API::HooksAPI.new(connection)
      GitHubV3API::Hook.should_receive(:new_with_all_data).with(api, :hook_hash).and_return(:hook)
      api.get('octocat', 'hello-world', 'hook-id').should == :hook
    end

    it 'raises GitHubV3API::NotFound instead of a RestClient::ResourceNotFound' do
      connection = mock(GitHubV3API)
      connection.should_receive(:get) \
        .and_raise(RestClient::ResourceNotFound)
      api = GitHubV3API::HooksAPI.new(connection)
      lambda { api.get('octocat', 'hello-world', 'hook-id') }.should raise_error(GitHubV3API::NotFound)
    end
  end
end
