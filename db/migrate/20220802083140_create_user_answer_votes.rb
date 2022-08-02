class CreateUserAnswerVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_answer_votes do |t|
      t.integer :answer_id, index: true
      t.integer :user_id, index: true

      t.boolean :liked
      t.boolean :disliked

      t.timestamps
    end
  end
end
