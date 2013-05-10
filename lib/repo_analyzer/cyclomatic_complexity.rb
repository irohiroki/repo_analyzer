module RepoAnalyzer
  class CyclomaticComplexity
    require 'roodi'

    class MethodCheck < Roodi::Checks::CyclomaticComplexityMethodCheck
      def result
        @result ||= []
      end

      def evaluate_matching_end
        result << Method.new(@node.file, @node.line, @method_name, @count)
      end
    end

    class Method
      attr_reader :count

      def initialize(file, line, name, count)
        @file, @line, @name, @count = file, line, name, count
      end

      def location
        "#{@file}:#{@line} `#{@name}'"
      end
    end

    def self.measure(root, round = 2)
      methods = Dir.glob("#{root}/lib/**/*.rb").map{|filename| check_file(filename) }.flatten
      if methods.any?
        total   = methods.map(&:count).inject(&:+)
        average = (total.to_f / methods.size).round(round)
        worst   = methods.sort_by(&:count).last

        {
          cc_average: average,
          cc_worst: worst.count,
          cc_worst_method: worst.location,
          cc_measured_at: Time.now.utc,
        }
      else
        {skipped: 'cc'}
      end
    end

    def self.check_file(filename)
      check = MethodCheck.make('complexity' => 0)
      checker = Roodi::Core::CheckingVisitor.new([check])
      check.start_file(filename)
      node = parse(filename, File.read(filename))
      node.accept(checker) if node
      check.end_file(filename)
      check.result
    end

    def self.parse(filename, content)
      begin
        Roodi::Core::Parser.new.parse(content, filename)
      rescue Exception => e
        puts "#{filename} looks like it's not a valid Ruby file.  Skipping..." if ENV["ROODI_DEBUG"]
        nil
      end
    end
  end
end
