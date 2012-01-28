#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  $.get "/posts", (posts, textStatus, xhr) ->
    window.router = new App.Routers.PostsRouter(posts: posts)
    Backbone.history.start()