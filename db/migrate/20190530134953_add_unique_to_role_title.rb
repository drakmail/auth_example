class AddUniqueToRoleTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :roles, :title, unique: true
    change_column_null :roles, :title, false
  end
end
