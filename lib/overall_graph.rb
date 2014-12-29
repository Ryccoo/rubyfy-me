require 'result_graph'

class OverallGraph
  attr_reader :points

  def initialize
    @benchmarks = RubyBenchmark.includes(:ruby_versions, :results).all

    @versions = Result.includes(:ruby_version).all.map { |r| "#{r.ruby_version.display_name} #{r.gcc}" }.uniq
    @versions.each do |v|
      ((@points ||= {})[:time_all] ||= {})[v] = 0
      ((@points ||= {})[:time_available] ||= {})[v] = 0
      ((@points ||= {})[:memory_all] ||= {})[v] = 0
      ((@points ||= {})[:memory_available] ||= {})[v] = 0
    end
  end

  def compute_all
    time_overall_score_all
    time_overall_score_available
    memory_overall_score_all
    memory_overall_score_available

    self
  end

  def time_overall_score_all
    overall_score(:time_all, :average, false)
  end

  def time_overall_score_available
    overall_score(:time_available, :average, true)
  end

  def memory_overall_score_all
    overall_score(:memory_all, :memory_average, false)
  end

  def memory_overall_score_available
    overall_score(:memory_available, :memory_average, true)
  end

  private

  def overall_score(name, field, skip_missing_results)
    @benchmarks.each do |benchmark|
      averages = ResultGraph.new(benchmark).average_for_gcc_n_version
      times = {}
      averages.each do |gcc_version, ruby_versions|
        ruby_versions.each do |ruby_version, results|
          times["#{ruby_version} #{gcc_version}"] = results[field]
        end
      end

      found = []
      points = 1

      times.values.sort.each do |v|
        version = times.key(v)
        found << version
        @points[name][version] += points if @points[name][version]

        points += 1
        times.delete(version)
      end

      if skip_missing_results
        (@versions - found).each do |v|
          @points[name].delete(v)
        end
      else
        (@versions - found).each do |v|
          @points[name][v] += points
        end
      end

    end

  end

end