json.merge! proposal.as_json
json.partial! 'api/v1/photos/photo', photo: proposal.photo if proposal.photo.present?
