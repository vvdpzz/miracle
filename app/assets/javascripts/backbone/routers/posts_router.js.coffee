class App.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new App.Collections.PostsCollection()
    @posts.reset options.posts

  routes:
    "!/search/:q"   : "search"
    "!/:id"         : "showUser"
    "!/tagged/:id"  : "showTag"
    "!"             : "index"
    ".*"            : "index"

  index: ->
    $("ul.nav li").removeClass("active")
    @view = new App.Views.Posts.IndexView(posts: @posts)
    $("#page-container").html(@view.render().el)
    $("ul.nav li.home").addClass("active")

  showUser: (id) ->
    $("ul.nav li").removeClass("active")
    $.get "/users/#{id}", (user, textStatus, xhr) ->
      @view = new App.Views.Users.ShowView(model: user)
      $("#page-container").html(@view.render().el)

  showTag: (id) ->
    $("ul.nav li").removeClass("active")
    $.get "/tagged/#{id}", (data, textStatus, xhr) ->
      @taggedPosts = new App.Collections.PostsCollection()
      @taggedPosts.reset data.posts
      @view = new App.Views.Tags.ShowView(posts: @taggedPosts, tag: data.tag, users: data.users)
      $("#page-container").html(@view.render().el)
    $("ul.nav li.topics").addClass("active")
  
  search: (q) ->
    $("ul.nav li").removeClass("active")
    $.get "/search/#{q}", (data, textStatus, xhr) ->
      $("#search-query").val("")
      @resultPosts = new App.Collections.PostsCollection()
      @resultPosts.reset data.posts
      @view = new App.Views.Search.ShowView(posts: @resultPosts, q: data.q)
      $("#page-container").html(@view.render().el)