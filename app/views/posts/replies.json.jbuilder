json.replies(@posts) do |json, post|
  json.partial! post
end
if @post
  json.rt do |json|
    json.partial! @post if @post
  end
end