class UpdateTitleIndexForRoles < ActiveRecord::Migration[5.2]
  def change
    change_column_null :roles, :title, true
  end
end
