App.Views.Tags ||= {}

class App.Views.Tags.ShowView extends Backbone.View
  template: JST["backbone/templates/tags/show"]
  tagTemplate: JST["backbone/templates/tags/description"]
  
  events:
    "click .follow-text": "followTag"
    "click .unfollow-text": "unfollowTag"
  
  initialize: () ->
    @options.posts.bind('reset', @addAll)
  
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
    
  render: =>
    $(@el).html(@template(posts: @options.posts))
    $(@el).append(@tagTemplate(tag: @options.tag))
    @addAll()
    return this
  
  followTag: (e) =>
    @$(".follow-combo").removeClass("not-following").addClass("following")
    $.post "/tagships", tag: e.currentTarget.dataset.tagId, (data, textStatus, xhr) ->
      
  
  unfollowTag: (e) =>
    @$(".follow-combo").removeClass("following").addClass("not-following")
    $.ajax url: "/tagships/#{e.currentTarget.dataset.tagId}", type: "DELETE", dataType: "json",
      complete: ->
        console.log "complete"
      success: ->
        console.log "success"
        error: ->
          console.log "error"
