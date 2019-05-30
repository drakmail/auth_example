class AddUniqueToPermissionAction < ActiveRecord::Migration[5.2]
  def change
    add_index :permissions, [:action, :resource], unique: true, where: "(resource IS NOT NULL)"
    add_index :permissions, :action, unique: true, where: "(resource IS NULL)"
    change_column_null :permissions, :action, false
  end
end
