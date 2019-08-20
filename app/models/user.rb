# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  # Encrypt password
  has_secure_password
  # Model associations
  has_many :todos, foreign_key: :created_by
  # Model validations
  validates_presence_of :name, :email, :password_digest
end
