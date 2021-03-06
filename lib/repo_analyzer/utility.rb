module RepoAnalyzer
  module Utility
    def analyze(repos)
      repos.each do |repo|
        $stderr.puts repo.full_name
        res = repo.with_tree do |tree|
          if File.exist?("#{tree}/lib")
            [Abc, CyclomaticComplexity, Flog].each do |metric|
              result = metric.measure(tree).each{|k, v| repo[k] = v }
              break if result[:invalid_code] || result[:skipped]
            end
          else
            repo[:skipped] = true
          end
        end
        if StandardError === res
          repo[:skipped] = 'http'
        end
        repo.save
      end
    end

    module_function :analyze
  end
end
