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

  def compilers_overview(results)
    benchmarks = {}
    results.each do |r|
      (benchmarks[r.ruby_benchmark] ||= []) << r
    end

    benchmark_averages = {}

    benchmarks.each do |benchmark, results|
      benchmark_averages[benchmark] = {}
      # get averages
      results = average_for_version(results, with_compiler_separation: true)
      results.each do |ruby_version, compilers|
        binding.pry if compilers.nil?
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
    end

    binding.pry
  end

end