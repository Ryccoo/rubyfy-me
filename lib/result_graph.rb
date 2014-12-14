class ResultGraph

  def initialize(benchmark)
    @benchmark = benchmark
    @results = benchmark.results
  end

  def average_for_version
    averages = {}
    @results.each do |r|
      averages[r.ruby_version.display_name] ||= {
        sum: 0,
        count: 0,
        average: 0,
        implementation: r.ruby_version.implementation
      }
      averages[r.ruby_version.display_name][:sum] += r.time
      averages[r.ruby_version.display_name][:count] += +1
    end

    averages.map {|k,v| averages[k][:average] = v[:sum] / v[:count].to_f }
    averages
  end

end