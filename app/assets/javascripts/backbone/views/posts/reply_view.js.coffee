App.Views.Posts ||= {}

class App.Views.Posts.ReplyView extends Backbone.View
  template: JST["backbone/templates/posts/dialog"]

  events:
    "click .twttr-dialog-close": "closeReplyDialog"
    "keyup textarea": "toggleButton"
    "click .tweet-button": "save"

  tagName: "div"
  className: "twttr-dialog-container draggable ui-draggable"

  toggleButton: (e) ->
    @$(".tweet-counter").val(140 - e.target.value.length)
    if e.target.value.length == 0
      $(@el).find(".tweet-button").removeClass("primary-btn").addClass("disabled")
    else
      $(@el).find(".tweet-button").removeClass("disabled").addClass("primary-btn")

  closeReplyDialog: (e)->
    $(".twttr-dialog-overlay").remove()
    $(".twttr-dialog-wrapper").empty().hide()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @collection = @options.posts
    @model = new App.Models.Post(
      text: $(@el).find(".twitter-anywhere-tweet-box-editor").val()
      in_reply_to_post_id: @options.postId
    )
    @collection.create(@model.toJSON(),
      success: (post) =>
        @addOneToHead(post)
        $(".twttr-dialog-overlay").remove()
        $(".twttr-dialog-wrapper").empty().hide()

      error: (post, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
  
  addOneToHead: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    $("#stream-items").prepend(view.render().el)
    $('time').sensible(option)
    
  render: ->
    $(@el).html(@template({nickname: @options.nickname, avatar: @options.avatar, content: @options.content}))
    $(@el).css({top: "0px", width: "500px", height: "auto", visibility: "visible", display: "block"})
    $("body").append('<div class="twttr-dialog-overlay" style="display: block; "></div>')
    return this
