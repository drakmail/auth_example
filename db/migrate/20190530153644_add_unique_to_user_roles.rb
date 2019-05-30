class AddUniqueToUserRoles < ActiveRecord::Migration[5.2]
  def change
    add_index :user_roles, [:user_id, :role_id], unique: true
  end
end
