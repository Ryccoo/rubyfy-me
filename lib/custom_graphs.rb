class CustomGraphs

  def self.parallelism(query)

    by_rubies = {}
    ruby_averages = {}
    # group by ruby
    query.each do |r|
      (by_rubies[r.ruby_version] ||= []) << r
    end

    # compute averages
    by_rubies.each do |ruby, results|
      score = 0
      time = 0
      count = 0
      results.each do |result|
        next if result.stderr =~ /WARNING: Highly suspect results/
        if data = result.stdout.match(/Total time: ([0-9\.]+)s\nConcurrency score: ([\-0-9\.]+)/)
          time += data[1].to_f
          score += data[2].to_f
          count += 1
        end
      end
      ruby_averages[ruby] = {
        time: time / results.count,
        score: score / results.count,
      } if count > 0
    end

    ruby_averages
  end

end