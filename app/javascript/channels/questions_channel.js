import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    connected() {
        console.log('Connected')
        this.perform('follow')
    },

    received(data) {
        $("td:contains('No questions asked yet')").hide()
        $('tbody').append(data)
    }
})