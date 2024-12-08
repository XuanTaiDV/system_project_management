class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, uniqueness: { scope: :project_id }

  enum status: {
    open: 1,
    in_progress: 2,
    done: 3
  }

  scope :on_track, -> { where(status: [statuses[:open], statuses[:in_progress]])}
end
