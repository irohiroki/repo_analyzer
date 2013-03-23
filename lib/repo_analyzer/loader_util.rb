module RepoAnalyzer
  module LoaderUtil
    def load_repositories_upto(id_end)
      loop do
        last = Repository.last
        break if last.github_id >= id_end
        $stderr.puts "fetch since #{last.github_id}..."
        load_repositories since: last.github_id
      end
    end
  end
end
