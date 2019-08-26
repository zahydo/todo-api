# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  title      :string
#  created_by :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TodoSerializer < ActiveModel::Serializer
  # Attributes to be serialized
  attributes :id, :title, :created_by, :created_at, :updated_at
  # Model association
  has_many :items
end
