Apipie.configure do |config|
  config.api_version             = "v1"
  config.app_name                = "RubyBench"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apidoc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
end
