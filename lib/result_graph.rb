class ResultGraph

  def initialize(benchmark = nil)
    @benchmark = benchmark
    @results = benchmark.try(:results)
  end

  def average_for_version(results = @results, options = {})
    averages = {}
    results.each do |r|
      if options[:with_compiler_separation]
        averages[r.ruby_version.display_name] ||= {}
        averages[r.ruby_version.display_name][r.gcc] ||= {
          time_sum: 0,
          count: 0,
          average: 0,
          memory_average: 0,
          memory_total_average: 0,
          implementation: r.ruby_version.implementation,
          memory_sum: 0,
          memory_total_sum: 0,
          runs: []
        }
        averages[r.ruby_version.display_name][r.gcc][:time_sum] += r.time
        averages[r.ruby_version.display_name][r.gcc][:memory_sum] += r.memory
        averages[r.ruby_version.display_name][r.gcc][:memory_total_sum] += r.total_memory
        averages[r.ruby_version.display_name][r.gcc][:count] += +1
        averages[r.ruby_version.display_name][r.gcc][:runs] << {
          time: r.time,
          memory: r.memory,
          total_memory: r.total_memory
        }
      else
        averages[r.ruby_version.display_name] ||= {
          time_sum: 0,
          count: 0,
          average: 0,
          memory_average: 0,
          memory_total_average: 0,
          implementation: r.ruby_version.implementation,
          memory_sum: 0,
          memory_total_sum: 0,
          runs: []
        }
        averages[r.ruby_version.display_name][:time_sum] += r.time
        averages[r.ruby_version.display_name][:memory_sum] += r.memory
        averages[r.ruby_version.display_name][:memory_total_sum] += r.total_memory
        averages[r.ruby_version.display_name][:count] += +1
        averages[r.ruby_version.display_name][:runs] << {
          time: r.time,
          memory: r.memory,
          total_memory: r.total_memory
        }
      end
    end

    if options[:with_compiler_separation]
      averages.map do |ruby_version, compiler|
        compiler.map do |k, v|

          averages[ruby_version][k][:average] = v[:time_sum] / v[:count].to_f
          averages[ruby_version][k][:memory_average] = v[:memory_sum] / v[:count].to_f
          averages[ruby_version][k][:memory_total_average] = v[:memory_total_sum] / v[:count].to_f
        end
      end
    else
      averages.map do |k,v|
        averages[k][:average] = v[:time_sum] / v[:count].to_f
        averages[k][:memory_average] = v[:memory_sum] / v[:count].to_f
        averages[k][:memory_total_average] = v[:memory_total_sum] / v[:count].to_f
      end
    end

    averages
  end

  def compilers_overview(results = @results)
    benchmarks = {}
    results.each do |r|
      (benchmarks[r.ruby_benchmark] ||= []) << r
    end

    benchmark_averages = {}
    benchmarks_percentages = {}

    benchmarks.each do |benchmark, results|
      benchmark_averages[benchmark] = {}
      benchmarks_percentages[benchmark] = {}
      # get averages
      results = average_for_version(results, with_compiler_separation: true)
      results.each do |ruby_version, compilers|
        benchmark_averages[benchmark][ruby_version] = {}
        tmp = {
          version_average_time: 0,
          version_average_memory: 0,
          version_average_total_memory: 0,
          count: 0
        }
        compilers.each do |compiler, data|
          tmp[:version_average_time] += data[:average]
          tmp[:version_average_memory] += data[:memory_average]
          tmp[:version_average_total_memory] += data[:memory_total_average]
          tmp[:count] += 1
        end
        tmp = {
          version_average_time: tmp[:version_average_time] / tmp[:count],
          version_average_memory: tmp[:version_average_memory] / tmp[:count],
          version_average_total_memory: tmp[:version_average_total_memory] / tmp[:count]
        }

        benchmark_averages[benchmark][ruby_version] = tmp
      end # end get averages

      results.each do |ruby_version, compilers|
        benchmarks_percentages[benchmark][ruby_version] = {}
        compilers.each do |compiler,data|
          benchmarks_percentages[benchmark][ruby_version][compiler] = {
            time: ((data[:average] * 100.0) / benchmark_averages[benchmark][ruby_version][:version_average_time]) - 100,
            memory: ((data[:memory_average] * 100.0) / benchmark_averages[benchmark][ruby_version][:version_average_memory]) - 100,
            total_memory: ((data[:memory_total_average] * 100.0) / benchmark_averages[benchmark][ruby_version][:version_average_total_memory]) - 100
          }
        end
      end
    end

    version_compiler_percentages = {}
    benchmarks_percentages.each do |benchmark, ruby_versions|
      ruby_versions.each do |ruby_version, compilers|
        version_compiler_percentages[ruby_version] = {}
        compilers.each do |compiler, data|
          version_compiler_percentages[ruby_version][compiler] ||= {
            time: 0,
            memory: 0,
            total_memory: 0
          }

          version_compiler_percentages[ruby_version][compiler][:time] += data[:time]
          version_compiler_percentages[ruby_version][compiler][:memory] += data[:memory]
          version_compiler_percentages[ruby_version][compiler][:total_memory] += data[:total_memory]

        end
      end
    end

    version_compiler_percentages
  end

  def versions_overview(results = @results)
    benchmarks = {}
    versions_count = results.collect(&:ruby_version).uniq.count

    results.each do |r|
      (benchmarks[r.ruby_benchmark] ||= []) << r
    end

    benchmark_averages = {}
    benchmarks_percentages = {}
    version_percentages = {}

    benchmarks.each do |benchmark, results|

      # skip if benchmark was not completed by all versions
      next if results.collect(&:ruby_version).uniq.count != versions_count
      benchmark_averages[benchmark] = {
        version_average_time: 0,
        version_average_memory: 0,
        version_average_total_memory: 0,
        count: 0
      }
      benchmarks_percentages[benchmark] = {}
      results = average_for_version(results)

      results.each do |ruby_version, data|
        benchmark_averages[benchmark][:version_average_time] += data[:average]
        benchmark_averages[benchmark][:version_average_memory] += data[:memory_average]
        benchmark_averages[benchmark][:version_average_total_memory] += data[:memory_total_average]
        benchmark_averages[benchmark][:count] += 1
      end

      benchmark_averages[benchmark] = {
        version_average_time:  benchmark_averages[benchmark][:version_average_time] /  benchmark_averages[benchmark][:count],
        version_average_memory:  benchmark_averages[benchmark][:version_average_memory] /  benchmark_averages[benchmark][:count],
        version_average_total_memory:  benchmark_averages[benchmark][:version_average_total_memory] /  benchmark_averages[benchmark][:count]
      }

      results.each do |ruby_version, data|
        benchmarks_percentages[benchmark][ruby_version] = {
          time: ((data[:average] * 100.0) / benchmark_averages[benchmark][:version_average_time]) - 100,
          memory: ((data[:memory_average] * 100.0) / benchmark_averages[benchmark][:version_average_memory]) - 100,
          total_memory: ((data[:memory_total_average] * 100.0) / benchmark_averages[benchmark][:version_average_total_memory]) - 100
        }

        version_percentages[ruby_version] ||= {
          time: 0,
          memory: 0,
          total_memory: 0
        }
        version_percentages[ruby_version][:time] += benchmarks_percentages[benchmark][ruby_version][:time]
        version_percentages[ruby_version][:memory] += benchmarks_percentages[benchmark][ruby_version][:memory]
        version_percentages[ruby_version][:total_memory] += benchmarks_percentages[benchmark][ruby_version][:total_memory]
      end
    end

    version_percentages.each do |ruby_version, data|
      version_percentages[ruby_version] = {
        time: data[:time] / benchmark_averages.keys.count,
        memory: data[:memory] / benchmark_averages.keys.count,
        total_memory: data[:total_memory] / benchmark_averages.keys.count
      }
    end

    version_percentages
  end

end