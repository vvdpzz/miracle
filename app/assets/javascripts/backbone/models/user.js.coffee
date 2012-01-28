class App.Models.User extends Backbone.Model
  paramRoot: 'user'
  url: '/users'

  defaults:
    name: null
    nickname: null
    email: null
    location: null
    bio: null
    avatar_url: null
    html_url: null
    followers_count: null
    friends_count: null
    favourites_count: null
    posts_count: null