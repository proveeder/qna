class CommentsChannel < ApplicationCable::Channel
  def follow_question_comments
    stream_from 'question_comments'
  end

  def follow_answer_comments
    stream_from 'answer_comments'
  end
end
