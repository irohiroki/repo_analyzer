module RepoAnalyzer
  class Repository
    require 'repo_analyzer/tree'

    include Mongoid::Document
    include Tree
  end
end
