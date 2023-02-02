$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-links', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })

    $(document.body).on('ajax:error', function(e) {
        if (e.detail[0].error !== undefined ) {
            var error = e.detail[0].error
        } else {
            var error = e.detail[0]
        }

        window.scrollTo(0,0);
        $('.flash-container').html('<div class="alert alert-warning alert-dismissable fade show" role="alert" >' +
            '<svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Info:">\n' +
            '<use xlink:href="#info-fill"></use>\n' + '</svg>' +
            '<button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close">' +
            '</button>' + error + '</div>')
    })
});
