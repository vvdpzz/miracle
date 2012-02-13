App.Views.Search ||= {}

class App.Views.Search.ShowView extends Backbone.View
  template: JST["backbone/templates/search/show"]
  
  initialize: () ->
    @options.posts.bind('reset', @addAll)
  
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
    
  render: =>
    $(@el).html(@template(posts: @options.posts ))
    @$(".flex-table-input").val(@options.q)
    @$(".stream-title").html("Posts")
    @addAll()
    return this
