import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel" }, {
  connected() {
    this.perform('follow_question_comments')
    this.perform('follow_answer_comments')
  },

  received(data) {
    let type = data['commentable_type'].toLowerCase()
    let commentable_id = parseInt(data['commentable_id'])
    let text = data['text']
    if (type === 'question') {
      $(`#question-${commentable_id}`).find('.comments').append(`<div class="comment-body"><p>${text}</p></div>`)
    }
     if (type === 'answer') {
       $(`#answer-${commentable_id}`).find('.comments').append(`<div class="comment-body"><p>${text}</p></div>`)
     }
  }
})