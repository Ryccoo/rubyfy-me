versions ||= @versions

json.versions do
  json.array! versions do |version|
    json.partial! 'api/v1/ruby_versions/version', :version => version
  end
end
json.count versions.count
