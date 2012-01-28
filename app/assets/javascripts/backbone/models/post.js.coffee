class App.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    avatar_url: null
    created_at: null
    entities: null
    geo_lat: null
    geo_long: null
    id: null
    in_reply_to_post_id: null
    in_reply_to_user_id: null
    name: null
    nickname: null
    text: ""
    user_id: null

class App.Collections.PostsCollection extends Backbone.Collection
  model: App.Models.Post
  url: '/posts'