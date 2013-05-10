module RepoAnalyzer
  class Repository
    require 'repo_analyzer/tree'

    include Mongoid::Document
    include Tree

    scope :pristine, ->{ where(flog_worst: nil).where(skipped: nil).where(invalid_code: nil) }
    scope :ruby, ->{ where(language: 'Ruby') }
  end
end
