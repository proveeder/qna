class CreateUserQuestionVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_question_votes do |t|
      t.integer :question_id, index: true
      t.integer :user_id, index: true

      t.boolean :liked
      t.boolean :disliked

      t.timestamps
    end
  end
end
