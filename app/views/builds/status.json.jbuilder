json.id @build.id
json.model @build.model_id
json.status @build.status
json.run_by @build.run_by
json.date_scheduled @build.date_scheduled
json.date_completed @build.date_completed
json.data_directory @build.data_directory
json.software_revision @build.software_revision

json.inputs @build.build_inputs do |input|
  json.name input.name
  json.value input.value_id
end

