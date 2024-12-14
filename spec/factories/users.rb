# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tainx#{n}@gmail.com" }
    password { '123' }
    password_confirmation { '123' }
  end
end
