App.cable.subscriptions.create { channel: "AnswersChannel", question_id: gon.question_id },
  connected: ->
    @follow()

  follow: ->
    return unless gon.question_id
    @perform 'follow'

  received: (data) ->
    $('.answers').append(JST["templates/answer"]({ data: data }))
