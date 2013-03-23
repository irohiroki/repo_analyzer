require 'repo_analyzer/loader_util'

module RepoAnalyzer
  class Loader
    include LoaderUtil

    attr_accessor :octokit_client

    def initialize
      require 'io/console'
      $stdout.print 'user: '
      user = $stdin.gets.chomp
      $stdout.print 'password: '
      password = $stdin.noecho(&:gets).chomp
      $stdout.puts
      self.octokit_client = Octokit::Client.new(login: user, password: password)
    end

    def load_repositories(options = {})
      octokit_client.all_repositories(options).each do |repo|
        repo[:github_id] = repo[:id]
        Repository.create repo
      end
    end

    def load_repository(repo_key)
      repo_hash = octokit_client.repository(repo_key)
      repo_hash[:loaded_at] = Time.now

      repo = Repository.where(github_id: repo_hash[:id]).first
      if repo
        repo.update_attributes(repo_hash)
      else
        repo_hash[:github_id] = repo_hash[:id]
        Repository.create repo_hash
      end
    end
  end
end
