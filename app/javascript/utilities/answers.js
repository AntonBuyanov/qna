$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-links', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })
});
