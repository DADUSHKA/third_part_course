$(document).on('turbolinks:load', function () {
  $('.question').on('ajax:success', function(e) {
    var question = e.detail[0];
    $el = $('.question');
    inset($el, question)
  });

  $('.answers').on('ajax:success', function (e) {
    var answer = e.detail[0];
    $el = $('.answer-' + answer.id);
    inset($el, answer)
  });
});

function inset(el, resource) {
  el.find('.vote').html('<p>'+ resource.klass + ' ' + 'like:' + ' ' + resource.choice + '</p>')
  el.find('.like').toggle();
  el.find('.deselecting').toggle()
}
