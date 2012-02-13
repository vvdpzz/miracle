json.posts(@posts) do |json, post|
  json.partial! post
end
json.q params[:q]