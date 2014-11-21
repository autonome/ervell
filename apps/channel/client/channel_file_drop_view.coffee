Backbone = require "backbone"
_ = require 'underscore'
sd = require("sharify").data
mediator = require '../../../lib/mediator.coffee'

module.exports = class ChannelFileDropView extends Backbone.View
  events:
    'dragenter'                     : 'handleDrag'
    'dragleave .channel--drop-zone' : 'clearDrag'

  initialize: (options)->
    @channel = options.channel
    @blocks = options.blocks

    @setupFileDrop()

  handleDrag: (e)->
    $('.channel--drop-zone').addClass('is-droppable')

  clearDrag: (e) ->
    $('.channel--drop-zone').removeClass('is-droppable')

  setupFileDrop: ->

    @$("#fileupload").fileupload
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png|ai|eps|kml|kmz|mb|ma|tex|texi|texinfo|tfm|fla|webm|ind|indd|key|pages|pdf|epub|psd|torrent|mp3|wav|aac|oga|ogg|wma|midi|aiff|mpeg|mpg|mpg4|mp4|mp4v|swa|swf|ttc|ttf|otf|pgp|numbers|fxp|latex|mov|avi|h264|ogv|docx|doc|ppt|pptx|xls|xlsx|xlt|tif|tiff|webloc)$/i
      maxFileSize: 104857600 # 100MB
      dropZone: @$el
      autoUpload: true
      dataType: "XML"
      fileInput: @$("input:file")

      drop: (e, data) ->
        console.log 'drop', e, data
        mediator.publish "files:dropped",
          count: data.files.length

      formData: (form) ->
        data     = form.serializeArray()
        fileType = ""
        fileType = @files[0].type if "type" of @files[0]

        data.push
          name: "Content-Type"
          value: fileType

        data[0].value = data[0].value.replace ":uuid", view.uniqueId()

        return data

      fail: (e, data) ->
        mediator.publish "files:fail"

      start: (e, data) ->
        mediator.publish "files:start"

      done: (e, data) ->
        # Parse XML response and get image URL
        xmlDoc   = $.parseXML(data.jqXHR.responseText)
        location = $(xmlDoc).find("Location").text()

        mediator.publish "upload:done", location

      stop: ->
        mediator.publish "upload:complete"

      progressall: (e, data) ->
        console.log('file upload progress', e, data)
        progress = parseInt(data.loaded / data.total * 100, 10)
        mediator.publish 'file:upload', progress