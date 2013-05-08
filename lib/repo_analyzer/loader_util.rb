module RepoAnalyzer
  module LoaderUtil
    def load_repositories_upto(id_end)
      loop do
        last = Repository.where(:github_id.lte => id_end).asc(:github_id).last
        break if last.github_id >= id_end
        to_read = id_end - last.github_id
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
        if repos.size >= to_read
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
            message = e.message
            $stderr.puts "\n" + message
            if /404: Not Found/ === message
              repo.destroy
            else
              sleep 1
              redo
            end
          end
        end
      end
      $stderr.puts
    end
  end
end
