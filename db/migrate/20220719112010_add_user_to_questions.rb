class AddUserToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :user, index: true
  end
end
