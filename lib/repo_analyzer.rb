require "repo_analyzer/version"

require 'irby' unless $0 == 'irb'
require 'mongoid'
require 'Octokit'

require 'models/repository'

ENV['MONGOID_ENV'] ||= 'development'
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))

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
  end
end
