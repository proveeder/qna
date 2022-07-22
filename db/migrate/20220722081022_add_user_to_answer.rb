class AddUserToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :user, index: true
  end
end
