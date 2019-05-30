class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.text :action
      t.text :resource

      t.timestamps
    end
  end
end
