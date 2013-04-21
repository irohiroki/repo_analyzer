# RepoAnalyzer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'repo_analyzer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install repo_analyzer

## Usage

### Launch

    repo_analyzer

Or, in the root directory,

    bundle install
    bundle exec irb -Ilib -rrepo_analyzer

### Load repositories

To load first 100 repositories into your local database,

    loader = RepoAnalyzer::Loader.new
    loader.load_repositories

it accepts `since` option, which is a starting repository id (exclusive.)

    loader.load_repositories(since: 100)

There are some utility methods. See: lib/repo_analyzer/loader_util.rb.

### Inspect

`Repository` is a document class for repositories.

    repo = RepoAnalyzer::Repository.where(language: 'Ruby').first

with `pp`,

    require 'pp'
    pp repo.attributes

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
