class App.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new App.Collections.PostsCollection()
    @posts.reset options.posts

  routes:
    "!/:id"      : "show"
    "!"         : "index"
    ".*"         : "index"

  index: ->
    @view = new App.Views.Posts.IndexView(posts: @posts)
    $("#page-container").html(@view.render().el)
    $("ul.nav li.home").addClass("active")

  show: (id) ->
    $("ul.nav li").removeClass("active")
    $.get "/users/#{id}", (user, textStatus, xhr) ->
      @view = new App.Views.Users.ShowView(model: user)
      $("#page-container").html(@view.render().el)