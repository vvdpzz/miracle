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
    @$(".stream-title").html("Search result for: #{@options.q}")
    @addAll()
    return this
