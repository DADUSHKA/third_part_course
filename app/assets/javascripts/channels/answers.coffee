App.cable.subscriptions.create { channel: "AnswersChannel", question_id: gon.question_id },
  connected: ->
    @follow()

  follow: ->
    @perform 'follow'

  received: (data) ->
    if (data['data']['answer'].author_id != gon.current_user?.id)
      $('.answers').append(JST["templates/answer"]({ data: data }))
