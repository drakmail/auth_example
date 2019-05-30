class AddUniqueToUserUsername < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :username, unique: true
    change_column_null :users, :username, false
  end
end
