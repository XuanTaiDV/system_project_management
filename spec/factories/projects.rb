# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { 'description' }
    user { FactoryBot.create(:user)}
  end
end
