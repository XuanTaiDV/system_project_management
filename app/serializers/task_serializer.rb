# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  status      :integer
#  due_date    :datetime
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  in_progress :integer          default(1)
#
class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :due_date, :project_id

  def due_date
    object.due_date.to_i
  end
end
