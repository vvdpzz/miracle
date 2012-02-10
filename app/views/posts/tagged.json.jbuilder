json.posts(@posts) do |json, post|
  json.partial! post
end
json.tag params[:id]