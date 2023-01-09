$(document).on('turbolinks:load', function() {
    $('.vote').each(function () {
        $(this).find('.vote-up')
            .on('ajax:success', (e) => {
                $(this).find('.vote-up').addClass('hidden');
                $(this).find('.vote-up-cancel').removeClass('hidden');
                $(this).find('.vote-down').prop('disabled', true);

                let resource = e.detail[0];
                $(`#${resource.votable_name}-rating-${resource.votable_id}`).html('<strong>' + resource.rating +
                    '</strong>');
            })

        $(this).find('.vote-up-cancel')
            .on('ajax:success', (e) => {
                $(this).find('.vote-up-cancel').addClass('hidden');
                $(this).find('.vote-up').removeClass('hidden');
                $(this).find('.vote-down').prop('disabled', false);

                let resource = e.detail[0];
                $(`#${resource.votable_name}-rating-${resource.votable_id}`).html('<strong>' + resource.rating +
                    '</strong>');
            })

        $(this).find('.vote-down')
            .on('ajax:success', (e) => {
                $(this).find('.vote-down').addClass('hidden');
                $(this).find('.vote-down-cancel').removeClass('hidden');
                $(this).find('.vote-up').prop('disabled', true);

                let resource = e.detail[0];
                $(`#${resource.votable_name}-rating-${resource.votable_id}`).html('<strong>' + resource.rating +
                    '</strong>');
            })

        $(this).find('.vote-down-cancel')
            .on('ajax:success', (e) => {
                $(this).find('.vote-down-cancel').addClass('hidden');
                $(this).find('.vote-down').removeClass('hidden');
                $(this).find('.vote-up').prop('disabled', false);

                let resource = e.detail[0];
                $(`#${resource.votable_name}-rating-${resource.votable_id}`).html('<strong>' + resource.rating +
                    '</strong>');
            })

        $('.vote').on('ajax:error', (e) => {
            let error = e.detail[0].error

            $('.flash-container').html('<div class="alert alert-warning alert-dismissable fade show" role="alert" >' +
                '<svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Info:">\n' +
                '<use xlink:href="#info-fill"></use>\n' + '</svg>' +
                '<button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close">' +
                '</button>' + error + '</div>');
        })
    })
});
