App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform "follow"
    ,
  received: (data) ->
    $('.question').append(JST["templates/question"]({ data: data }))
})

