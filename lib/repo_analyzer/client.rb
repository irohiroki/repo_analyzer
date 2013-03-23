module RepoAnalyzer
  class Client
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

    def fetch_upto(id_end)
      loop do
        last = Repository.last
        break if last.github_id >= id_end
        $stderr.puts "fetch since #{last.github_id}..."
        fetch since: last.github_id
      end
    end
  end
end
