
$(document).on('turbolinks:load', function(){
 $('.answers').on('click', '.edit-answer-link', function(e) {
   e.preventDefault();
   $(this).hide();
   var answerId = $(this).data('answerId');
   $('form#edit-answer-' + answerId).removeClass('hidden');
 });

 $('.answers').on('ajax:success', function(e) {
  var answer = e.detail[0];
  $el = $('.answer-' + answer.id);
  $el.find('.vote').html('<p>'+ answer.klass + ' ' + 'like:' + ' ' + answer.choice + '</p>')
  $el.find('.like').toggle();
  $el.find('.deselecting').toggle()
});
});
