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
class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, uniqueness: { scope: :project_id }

  enum status: {
    open: 1,
    in_progress: 2,
    done: 3
  }

  scope :on_track, -> { where(status: [statuses[:open], statuses[:in_progress]])}

  def self.ransackable_attributes(auth_object = nil)
    %w[
      description
      due_date
      project_id
      status
      created_at
      title
    ]
  end
end
