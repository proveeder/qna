class AddActivationToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :active, :boolean, default: true
    add_column :users, :activation_token, :string
  end
end
