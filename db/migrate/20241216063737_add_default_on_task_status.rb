class AddDefaultOnTaskStatus < ActiveRecord::Migration[7.0]
  def up
    change_column :tasks, :status, :integer, default: 1
  end

  def down
    remove_column :tasks, :status, :integer, default: nil
  end
end
