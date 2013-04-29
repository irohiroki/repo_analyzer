module RepoAnalyzer
  module Utility
    def analyze(repos)
      repos.each do |repo|
        repo.with_tree do |tree|
          if File.exist?("#{tree}/lib")
            [Abc, CyclomaticComplexity, Flog].each do |metric|
              metric.measure(tree).each{|k, v| repo[k] = v }
            end
          else
            repo[:skipped] = true
          end
        end
        repo.save
      end
    end

    module_function :analyze
  end
end
