class AddIndexToAuthorization < ActiveRecord::Migration[6.1]
  def change
    add_index :authorizations, [:provider, :uid]
  end
end
