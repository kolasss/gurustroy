json.merge! proposal.attributes
json.partial! 'api/v1/photos/photo', photo: proposal.photo if proposal.photo.present?
