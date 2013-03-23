require 'repo_analyzer/client_util'

module RepoAnalyzer
  class Client
    include ClientUtil

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

    def fetch(options = {})
      octokit_client.all_repositories(options).each do |repo|
        repo[:github_id] = repo[:id]
        Repository.create repo
      end
    end
  end
end