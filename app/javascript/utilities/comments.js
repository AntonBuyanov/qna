$(document).on('turbolinks:load', function() {
    $(document.body).on('click', '.add-comment', function(e) {
        e.preventDefault();
        $(this).hide();
        let resourceId = $(this).data('resourceId');
        let resourceType = $(this).data('resourceType');

        if (resourceType === 'Answer') {
            $('form#add-comment-answer-' + resourceId).removeClass('hidden');
        } else {
            $('form#add-comment-question-' + resourceId).removeClass('hidden');
        }
    })
});
