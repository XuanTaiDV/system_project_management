FactoryBot.define do
  factory :user do
    email { 'tainx1@gmail.com' }
    password { '123' }
    password_confirmation { '123' }
  end
end
