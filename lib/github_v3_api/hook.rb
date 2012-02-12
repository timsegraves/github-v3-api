# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Hook and provides access to its data attributes.
  class Hook < Entity
    attr_reader :created_at, :updated_at, :url, :name, :events, :active, 
      :config, :id
    
  end
end

