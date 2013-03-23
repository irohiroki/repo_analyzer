module RepoAnalyzer
  class Repository
    include Mongoid::Document

    validates_uniqueness_of :github_id
  end
end
