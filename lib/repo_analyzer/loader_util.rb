module RepoAnalyzer
  module LoaderUtil
    def load_repositories_upto(id_end)
      loop do
        last = Repository.last
        break if last.github_id >= id_end
        $stderr.puts "fetch since #{last.github_id}..."
        begin
          repos = load_repositories since: last.github_id
        rescue StandardError => e
          $stderr.puts e.message
          sleep 1
          redo
        end
        if repos.empty?
          $stderr.puts "no more repository."
          break
        end
      end
    end

    def load_repository_details(repos)
      $stderr.print 'loading'
      repos.each do |repo|
        unless repo[:loaded_at]
          $stderr.print '.'
          begin
            load_repository(repo.full_name)
          rescue StandardError => e
            $stderr.puts "\n" + e.message
            sleep 1
            redo
          end
        end
      end
      $stderr.puts
    end
  end
end
