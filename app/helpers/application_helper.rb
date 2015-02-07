module ApplicationHelper
  def active_page(name, action = nil)
    active = controller_name == name
    (active = active && action_name == action) if action

    'active' if active
  end

  def get_average_for_compilers_benchmark(results, field)
    average = count = 0
    results.values.each do |compilers|
      compilers.each do |compiler, data|
        average += data[field]
        count += 1
      end
    end

    (average / count)
  end

  def get_average_for_benchmark(results, field)
    average = count = 0
    results.each do |ruby_version, data|
      average += data[field]
      count += 1
    end

    (average / count)
  end
end
