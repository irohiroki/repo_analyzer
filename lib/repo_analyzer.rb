require "repo_analyzer/version"

require 'irby' unless $0 == 'irb'
require 'mongoid'
require 'Octokit'

require 'repo_analyzer/client'
require 'repo_analyzer/repository'

ENV['MONGOID_ENV'] ||= 'development'
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))
