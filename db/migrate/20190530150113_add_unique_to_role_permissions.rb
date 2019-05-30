class AddUniqueToRolePermissions < ActiveRecord::Migration[5.2]
  def change
    add_index :role_permissions, [:role_id, :permission_id], unique: true
  end
end
