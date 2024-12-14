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
class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :user_id
end
