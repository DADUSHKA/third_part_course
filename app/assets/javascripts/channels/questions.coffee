App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    console.log "Connected Vicstor!"
    @perform "follow"
    ,

  received: (data) ->
    console.log "received", data
    ,
    $('.question').append(JST["templates/question"]({ data: data }))

})

