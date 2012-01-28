App.Views.Users ||= {}

class App.Views.Users.ShowView extends Backbone.View
  template: JST["backbone/templates/users/show"]

  render: ->
    $(@el).html(@template(@model))
    return this
