class ChangeDueDateFromDateToDateTime < ActiveRecord::Migration[7.0]
  def up
    change_column :tasks, :due_date, :datetime
  end

  def down
    change_column :tasks, :due_date, :date
  end
end
