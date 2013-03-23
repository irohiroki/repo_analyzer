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
  end
end
