module ApplicationHelper
  def active_page(name, action = nil)
    active = controller_name == name
    (active = active && action_name == action) if action

    'active' if active
  end

  def get_average_for_compilers_benchmark(results, field)
    average = count = 0
    results.keys.sort.reverse.each do |ruby_version|
      compilers = results[ruby_version]
      compilers.keys.sort.each do |compiler|
        data = compilers[compiler]
        average += data[field]
        count += 1
      end
    end

    (average / count)
  end
end
