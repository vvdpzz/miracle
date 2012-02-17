App.Views.Posts ||= {}

class App.Views.Posts.PostView extends Backbone.View
  template: JST["backbone/templates/posts/post"]

  events:
    "click .destroy" : "destroy"

  tagName: "div"
  className: "stream-item expanding-stream-item"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    $(@el).attr("data-post-id", @model.toJSON().id)
    return this
