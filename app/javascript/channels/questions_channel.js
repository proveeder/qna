import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    connected() {
        this.perform('follow_question')
    },

    received(data) {
        $("td:contains('No questions asked yet')").hide()
        $('tbody').append(data)
    }
})