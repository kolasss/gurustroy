json.photo do
  json.id photo.id
  json.url do
    photo.file.versions.each do |name, version|
      json.set! name, version.url
    end
  end
end
