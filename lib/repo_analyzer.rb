require "repo_analyzer/version"

require 'irby' unless $0 == 'irb'
require 'mongoid'

require 'models/repository'

ENV['MONGOID_ENV'] ||= 'development'
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))

module RepoAnalyzer
  # Your code goes here...
end
