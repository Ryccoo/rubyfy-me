version ||= @version

json.id = version.id
json.name = version.implementation
json.version = version.name
json.created_at version.created_at
json.updated_at version.updated_at