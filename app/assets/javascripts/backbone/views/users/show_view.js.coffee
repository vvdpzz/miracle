App.Views.Users ||= {}

class App.Views.Users.ShowView extends Backbone.View
  template: JST["backbone/templates/users/show"]
  
  events:
    "click .follow-text": "followUser"
    "click .unfollow-text": "unfollowUser"
  
  render: ->
    $(@el).html(@template(@model))
    return this
  
  followUser: (e) =>
    @$(".follow-combo").removeClass("not-following").addClass("following")
    $.post "/friendships", user_id: e.currentTarget.dataset.userId, (data, textStatus, xhr) ->
      
  
  unfollowUser: (e) =>
    @$(".follow-combo").removeClass("following").addClass("not-following")
    $.ajax url: "/friendships/#{e.currentTarget.dataset.userId}", type: "DELETE", dataType: "json",
      complete: ->
        console.log "complete"
      success: ->
        console.log "success"
        error: ->
          console.log "error"
