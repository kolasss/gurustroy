json.merge! proposal.attributes
json.photo proposal.photo, :id, :file if proposal.photo.present?
