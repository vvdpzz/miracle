json.(@users) do |json, user|
  json.(user, :id, :name, :nickname)
end