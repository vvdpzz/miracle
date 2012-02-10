App.Views.Tags ||= {}

class App.Views.Tags.ShowView extends Backbone.View
  template: JST["backbone/templates/tags/show"]
  
  initialize: () ->
    @options.posts.bind('reset', @addAll)
  
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
    
  render: =>
    $(@el).html(@template(posts: @options.posts ))
    @$(".stream-title").html(@options.tag)
    @addAll()
    return this
