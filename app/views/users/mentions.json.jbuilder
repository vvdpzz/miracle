json.followings(@users) do |json, user|
  json.id user.id
  json.avatar user.avatar_url
  json.name user.nickname
  json.nickname user.name
end
json.tags(@tags) do |json, tag|
  json.(tag, :id, :name)
end