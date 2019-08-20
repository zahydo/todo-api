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

require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # Ensure User model has a 1:m relationship with the Todo model
  it { should have_many(:todos) }
  # Validation test
  # Ensure name, email and password_digest are present before save
  it { should validate_presence_of(:name) } 
  it { should validate_presence_of(:email) } 
  it { should validate_presence_of(:password_digest) } 
end
