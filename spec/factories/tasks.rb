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
FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Title #{n}" }
    description { 'task description'}
    status { 'open' }
    due_date { Time.current }
    project { FactoryBot.create(:project)}
  end
end
