json.(@posts) do |json, post|
  json.partial! post
end