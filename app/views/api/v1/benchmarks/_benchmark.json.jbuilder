benchmark ||= @benchmark
short ||= false

json.id benchmark.id
json.name benchmark.name
unless short
  json.author benchmark.author
  json.collection benchmark.benchmark_collection
  json.source_code benchmark.source
  json.created_at benchmark.created_at
  json.updated_at benchmark.updated_at
end