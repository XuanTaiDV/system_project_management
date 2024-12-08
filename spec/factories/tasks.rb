FactoryBot.define do
  factory :task do
    title { 'title' }
    description { 'task description'}
    status { 'open' }
    due_date { Time.current }
    project { FactoryBot.create(:project)}
  end
end
