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
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
  validates :password_confirmation, presence: true, if: -> { password.present? }

  has_many :projects

  def generate_token
    ::AuthToken.encode_payload(
      {
        email: email,
        user_id: id,
        exp: Time.current.to_i + 1.day.to_i
      }
    )
  end
end

