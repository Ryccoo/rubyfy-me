class ResultGraph

  def initialize(benchmark)
    @benchmark = benchmark
    @results = benchmark.results
  end

  def average_for_gcc_n_version
    gcc = {}
    @results.each do |r|
      (gcc[r.gcc] ||= []) << r
    end

    gcc.each do |k,v|
      gcc[k] = average_for_version(v)
    end

    gcc.each do |gcc_version, ruby_versions|
      ruby_versions.keys.each do |ruby_version|
        gcc.each do |ogv, orv|
          gcc[gcc_version].delete(ruby_version) unless gcc[ogv].keys.include? ruby_version
        end
      end
    end

    gcc
  end

  def average_for_version(results = @results)
    averages = {}
    results.each do |r|
      averages[r.ruby_version.display_name] ||= {
        sum: 0,
        count: 0,
        average: 0,
        implementation: r.ruby_version.implementation,
        memory_sum: 0
      }
      averages[r.ruby_version.display_name][:sum] += r.time
      averages[r.ruby_version.display_name][:memory_sum] += r.memory
      averages[r.ruby_version.display_name][:count] += +1
    end

    averages.map do |k,v|
      averages[k][:average] = v[:sum] / v[:count].to_f
      averages[k][:memory_average] = v[:memory_sum] / v[:count].to_f
    end
    averages
  end

end