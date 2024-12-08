class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :due_date, :project_id

  def due_date
    object.due_date.to_i
  end
end
