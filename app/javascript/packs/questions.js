// required to work with turbolinks
document.addEventListener("turbolinks:load", function() {
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
    $('.question a').click(function(event) {
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