require 'spec_helper'

describe GitHubV3API::Hook do
  describe 'attr_readers' do
    it 'should define attr_readers that pull values from the hook data' do
      fields = %w(created_at updated_at url name events active config id)
      fields.each do |f|
        hook = GitHubV3API::Hook.new_with_all_data(stub('api'), {f.to_s => 'foo'})
        hook.methods.should include(f.to_sym)
        hook.send(f).should == 'foo'
      end
    end
  end

  describe '#[]' do
    it 'returns the hook data for the specified key' do
      api = stub(GitHubV3API::HooksAPI)
      repo = GitHubV3API::Hook \
        .new_with_all_data(api, 'name' => 'hello-world', 'events' => ['push'])
      repo['name'].should == 'hello-world'
    end

    #it 'only fetches the data once' do
    #  api = mock(GitHubV3API::HooksAPI)
    #  api.should_receive(:get).once.with('octocat', 'hello-world', 'hook-id') \
    #    .and_return(GitHubV3API::Hook.new(api, 'name' => 'hello-world', 'events' => ['push']))
    #  repo = GitHubV3API::Hook.new(api, 'name' => 'hello-world', 'events' => ['push'])
    #  repo['name'].should == 'hello-world'
    #  repo['events'].should == ['push']
    #end
  end

end
