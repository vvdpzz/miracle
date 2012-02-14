json.posts(@posts) do |json, post|
  json.partial! post
end
json.tag do |json|
  json.name @tag.name
  json.followers_count @tag.cached_followers.length
  json.posts_count @tag.ctt.length
end