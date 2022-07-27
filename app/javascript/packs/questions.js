// required to work with turbolinks
document.addEventListener("turbolinks:load", function() {
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