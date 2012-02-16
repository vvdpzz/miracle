json.posts(@posts) do |json, post|
  json.partial! post
end
json.users(@users) do |json, user|
  json.(user, :id, :name, :nickname, :avatar_url, :bio)
end
json.tag do |json|
  json.id @tag.id
  json.name @tag.name
  json.followers_count @tag.cached_followers.length
  json.posts_count @tag.ctt.length
  json.is_following current_user.cached_tags.member? @tag.id
end