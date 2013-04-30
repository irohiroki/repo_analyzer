module RepoAnalyzer
  class Abc
    # bundle exec ruby -Ilib -rrepo_analyzer/abc -e "puts RepoAnalyzer::Abc.measure('/path/to/root').inspect"
    def self.measure(root, round = 2)
      lines = []
      IO.popen("cd #{root} && metric_abc `find lib -name '*.rb'`") do |f|
        while l = f.gets
          lines << Line.new(l)
        end
      end

      if lines.any?
        total   = lines.map(&:point).inject(&:+)
        average = (total.to_f / lines.size).round(round)
        worst   = lines.sort_by(&:point).last

        {
          abc_average: average,
          abc_worst: worst.point,
          abc_worst_method: worst.method,
          abc_measured_at: Time.now.utc,
        }
      else
        {invalid_code: true}
      end
    end

    class Line
      def initialize(line_string)
        @str = line_string
      end

      def method
        @method ||= @str[/[^:]*/]
      end

      def point
        @point ||= @str[/(?<=: )\d+/].to_i
      end
    end
  end
end
