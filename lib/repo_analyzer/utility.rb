module RepoAnalyzer
  module Utility
    def analyze(repos)
      repos.each do |repo|
        repo.with_tree do |tree|
          [Abc, CyclomaticComplexity, Flog].each do |metric|
            metric.measure(tree).each{|k, v| repo[k] = v }
          end
        end
        repo.save
      end
    end

    module_function :analyze
  end
end
