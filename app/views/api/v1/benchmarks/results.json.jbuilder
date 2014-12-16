results ||= @results

json.results do
  json.array! results do |result|
    json.partial! 'api/v1/results/result', :result => result
  end
end
json.count results.count
