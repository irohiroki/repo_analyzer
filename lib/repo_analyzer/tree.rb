require 'tmpdir'
require 'httpclient'

module RepoAnalyzer
  module Tree
    def with_tree
      Dir.mktmpdir do |dir|
        archive = File.open("#{dir}/archive.zip", 'w')
        HTTPClient.new.get_content(archive_uri) {|content| archive.write(content) }
        archive.close
        system "cd #{dir} && unzip -q #{archive.path}"
        yield "#{dir}/#{name}-#{default_branch}"
      end
    end

    def archive_uri
      "https://github.com/#{full_name}/archive/#{default_branch}.zip"
    end
  end
end
