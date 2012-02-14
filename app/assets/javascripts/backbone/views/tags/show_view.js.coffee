App.Views.Tags ||= {}

class App.Views.Tags.ShowView extends Backbone.View
  template: JST["backbone/templates/tags/show"]
  tagTemplate: JST["backbone/templates/tags/description"]
  
  initialize: () ->
    @options.posts.bind('reset', @addAll)
  
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
    
  render: =>
    $(@el).html(@template(posts: @options.posts, tag: @options.tag ))
    $(@el).append(@tagTemplate(tag: @options.tag))
    @addAll()
    return this
