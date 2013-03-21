# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'repo_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "repo_analyzer"
  spec.version       = RepoAnalyzer::VERSION
  spec.authors       = ["Hiroki Yoshioka"]
  spec.email         = ["irohiroki@gmail.com"]
  spec.description   = %q{github repository analyzing tool.}
  spec.summary       = %q{repository analyzer.}
  spec.homepage      = "https://github.com/irohiroki/repo_analyzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "irby"
  spec.add_dependency "mongoid"
  spec.add_dependency "octokit"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
