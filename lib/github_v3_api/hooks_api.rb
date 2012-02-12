# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Provides access to the GitHub Hooks API (http://developer.github.com/v3/repos/hooks/)
  #
  # example:
  #
  #   api = GitHubV3API.new(ACCESS_TOKEN)
  #
  #   # get list of your hooks for a repo
  #   my_hooks = api.hooks.list({:user => 'octocat', :repo => 'hello-world'})
  #   #=> returns an array of GitHubV3API::Hook instances
  #
  #   hook = api.hooks.get('octocat', 'hello-world', '1234')
  #   #=> returns an instance of GitHubV3API::Hook
  #
  #   hook.url
  #   #=> 'https://api.github.com/repos/octocat/Hello-World/hooks/1'
  #
  class HooksAPI
    # Typically not used directly. Use GitHubV3API#hooks instead.
    #
    # +connection+:: an instance of GitHubV3API
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubV3API::Hook instances representing a
    # list of hooks for a repo
    def list(user, repo_name)

      path = "/repos/#{user}/#{repo_name}/hooks"

      @connection.get(path).map do |hook_data|
        GitHubV3API::Hook.new(self, hook_data)
      end
    end

    # Returns a GitHubV3API::Hook instance for the specified +user+,
    # +repo_name+, and +id+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the hook, e.g. 42
    def get(user, repo_name, id, params={})
      hook_data = @connection.get("/repos/#{user}/#{repo_name}/hooks/#{id.to_s}", params)
      GitHubV3API::Hook.new_with_all_data(self, hook_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The hook #{user}/#{repo_name}/hooks/#{id} does not exist or is not visible to the user."
    end

    # Returns a GitHubV3API::Hook instance representing the hook
    # that it creates
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +data+:: the hash DATA with attributes for the hook, e.g. {:name => "omgbbq"}
    def create(user, repo_name, data={})
      raise MissingRequiredData, "Name and Config are required to create a hook" unless data[:name] && data[:config]
      hook_data = @connection.post("/repos/#{user}/#{repo_name}/hooks", data)
      GitHubV3API::Hook.new_with_all_data(self, hook_data)
    end

    # Returns a GitHubV3API::Hook instance representing the hook
    # that it updated
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the hook, e.g. 42
    # +data+:: the hash with attributes for the hook, e.g. {:name => "my name"}
    def update(user, repo_name, id, data={})
      hook_data = @connection.patch("/repos/#{user}/#{repo_name}/hook/#{id.to_s}", data)
      GitHubV3API::Hook.new_with_all_data(self, hook_data)
    end
  end
end

