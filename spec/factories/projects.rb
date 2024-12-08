FactoryBot.define do
  factory :project do
    name { 'project' }
    description { 'description' }
    user { FactoryBot.create(:user)}
  end
end
