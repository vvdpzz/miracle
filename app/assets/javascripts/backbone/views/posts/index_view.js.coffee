App.Views.Posts ||= {}

class App.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  convTemplate: JST["backbone/templates/posts/conversation"]
  
  events:
    "submit #new-tweet": "save"
    "click textarea": "rmCondensed"
    "blur textarea": "addCondensed"
    "keyup textarea": "toggleButton"
    "click .expanding-stream-item, .open-tweet, .close-tweet": "expandingStreamItem"
    "click .js-action-reply": "replyAction"
    "click .tweet-url": "openTweetUrl"
    
  initialize: () ->
    @options.posts.bind('reset', @addAll)
  
  openTweetUrl: (e)->
    e.stopPropagation()
  
  replyAction: (e)->
    e.preventDefault()
    e.stopPropagation()
    item = $(e.currentTarget).parents(".stream-item-header")
    if item.length == 0
      item = $(e.currentTarget).parents(".js-tweet-details-dropdown").siblings(".stream-item-header")
    nickname = item.find("span.username b").text()
    avatar = item.find("img.avatar").attr("src")
    content = item.siblings(".tweet-text").text()
    postId = $(e.currentTarget).parents(".stream-item").data("post-id")
    
    view = new App.Views.Posts.ReplyView({posts: this.options.posts, postId: postId, nickname: nickname, avatar: avatar, content: content})
    $(".twttr-dialog-wrapper").html(view.render().el).show()
    $(".twttr-dialog-wrapper .twitter-anywhere-tweet-box-editor").focus().val("@#{nickname} ")
  
  expandingStreamItem: (e) ->
    e.preventDefault()
    if $(e.currentTarget).hasClass("open")
      $(e.currentTarget).find(".original-tweet").removeClass("opened-tweet")
      $(e.currentTarget).css("margin", "0 0").removeClass("open").prev().removeClass("before-expanded").end().next().removeClass("after-expanded")
    else
      $(e.currentTarget).find(".original-tweet").addClass("opened-tweet")
      if $(e.currentTarget).prev().length != 0
        $(e.currentTarget).css("margin", "8px 0").addClass("open").prev().addClass("before-expanded").end().next().addClass("after-expanded")
      else
        $(e.currentTarget).css("margin-bottom", "8px").addClass("open").next().addClass("after-expanded")
      if not $(e.target).hasClass("close-tweet")
        postId = $(e.currentTarget).data("post-id")
        if postId != undefined
          that = this
          $.get "/posts/#{postId}/replies.json", (posts) ->
            if posts.length > 0
              $(e.currentTarget).find(".expansion-container").append(that.convTemplate({posts: posts}))
  
  rmCondensed: ->
    @$("form").closest(".tweet-box").removeClass("condensed")
  
  addCondensed: ->
    len = @model.get("text").length
    if len == 0
      @$("form").closest(".tweet-box").addClass("condensed")

  toggleButton: (e) ->
    @$(".tweet-counter").val(140 - e.target.value.length)
    if e.target.value.length == 0
      @$("form").find("button").removeClass("primary-btn").addClass("disabled")
    else
      @$("form").find("button").removeClass("disabled").addClass("primary-btn")
  
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    that = this
    @collection.create(@model.toJSON(),
      success: (post) =>
        @addOneToHead(post)
        @$("form")[0].reset()
        that.model.set({text: ""})
        @$("form").closest(".tweet-box").addClass("condensed")
        @$("form").find("button").removeClass("primary-btn").addClass("disabled")

      error: (post, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
  
  addOneToHead: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").prepend(view.render().el)
    @$('time').sensible(option)

  render: =>
    $(@el).html(@template(posts: @options.posts.toJSON() ))
    @addAll()
    @$('time').sensible(option)
    @collection = this.options.posts
    @model = new @collection.model()
    @$("form").backboneLink(@model)
    @$("textarea").mentionsInput
      triggerChar: ["@", "#"]
      onDataRequest: (mode, query, callback, triggerChar) ->
        data = []
        if triggerChar is "@"
          data = App.followings
        else
          data = App.hashtags
        data = _.filter(data, (item) ->
          item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
        )
        callback.call this, data
    return this
