module RepoAnalyzer
  class Flog
    def self.measure(root)
      IO.popen("cd #{root} && flog lib 2>&1") do |f|
        data = {}

        loop do
          case line = f.gets
          when /flog total/
            break
          when /warning/
            data = {flog_warned: true}
          when nil
            return {skipped: 'flog'}
          else
            print line
          end
        end

        average = parse_point(f.gets)
        raise 'No code to measure' if average.zero?
        f.gets # discard blank line
        worst_line = f.gets

        data.merge(
          flog_average: average,
          flog_worst: parse_point(worst_line),
          flog_worst_method: worst_line[/(?<=: ).*/],
          flog_measured_at: Time.now.utc,
        )
      end
    end

    def self.parse_point(line)
      line[/[\d.]+/].to_f
    end
  end
end
