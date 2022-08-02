// required to work with turbolinks
document.addEventListener("turbolinks:load", function() {
    // change ration on index questions page
    $(".change-answer-rating").on('ajax:complete', function(e) {
        let data = JSON.parse(e['detail'][0]['response']);
        let rating = data['rating']
        $(this).parent().find('p:contains("Rating:")').html(`Rating: ${rating}`)
    });

    // change ration on index questions page
    $(".change-question-rating").on('ajax:complete', function(e) {
        let data = JSON.parse(e['detail'][0]['response']);
        let rating = data['rating']
        $(this).parent().children('p').html(`Rating: ${rating}`)
    });

    // edit answer
    $('#edit-answer-link').click(function(event) {
        event.preventDefault();

        if ($(this).text() === 'Cancel') {
            $('.edit-answer').hide()
            $(this).text('Edit')
        }
        else {
            $('.edit-answer').show()
            $(this).text('Cancel')
        }
    });

    // edit question
    $('#edit-q-link').click(function(event) {
        event.preventDefault();

        if ($(this).text() === 'Cancel') {
            $('.edit-question').hide()
            $(this).text('Edit question')
        }
        else {
            $('.edit-question').show()
            $(this).text('Cancel')
        }
    });
});