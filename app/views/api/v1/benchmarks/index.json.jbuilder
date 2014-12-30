benchmarks ||= @benchmarks

json.benchmarks do
  json.array! benchmarks do |benchmark|
    json.partial! 'api/v1/benchmarks/benchmark', :benchmark => benchmark, :short => true
  end
end
json.count benchmarks.count