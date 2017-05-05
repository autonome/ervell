Backbone = require 'backbone'
mediator = require '../../../lib/mediator.coffee'
template = -> require('../templates/partials/_channel_groups.jade') arguments...

class ProfileView extends Backbone.View
  loading: false
  disabled: false
  threshold: -500
  page: 2

  initialize: ->
    @timer = setInterval @maybeLoad, 150

  maybeLoad: =>
    return false if @loading or 
      @disabled or 
      mediator.shared.state.get 'lightbox'

    total = document.body.scrollHeight
    scrollPos = (document.documentElement.scrollTop || document.body.scrollTop)
    progress = scrollPos + window.innerHeight * 4

    if (total - progress < @threshold)
      @loadNextPage() 

  loadNextPage: ->
    console.log('loadNextPage')
    @loading = true
    $.ajax 
      data: 
        page: @page
      url: "/api/#{sd.USER.slug}/profile"
      success: (response) =>
        @page++
        @loading = false
        
        $('.profile').append template 
          channels: response.channels
      
module.exports.init = ->
  new ProfileView
    el: $('.profile')