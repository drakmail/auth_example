class AddKindToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :kind, :integer, default: 0, null: false
  end
end
