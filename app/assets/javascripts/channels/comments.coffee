App.cable.subscriptions.create {channel: 'CommentsChannel', question_id: gon.question_id},
  connected: ->
    @follow()

  follow: ->
    @perform 'follow'

  received: (data) ->
    console.log "received", data
    if (data['comment_user_id'] != gon.current_user?.id)
      if(data['type'] == 'Question')
        $('.question-comments').append(data['comment'])
      else if(data['type'] == 'Answer')
        $('.answer-comments-'+ data['answer_id']).append(data['comment'])
