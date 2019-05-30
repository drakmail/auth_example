class RemoveKindFromUserRoles < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_roles, :kind, :integer
  end
end
