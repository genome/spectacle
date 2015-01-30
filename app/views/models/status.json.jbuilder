json.id @model.id
json.name @model.name
json.processing_profile @model.processing_profile_id
json.run_as @model.run_as
json.created_by @model.created_by
json.creation_date @model.creation_date
json.subject @model.subject_id
if @analysis_project
  json.analysis_project @analysis_project.id
end

