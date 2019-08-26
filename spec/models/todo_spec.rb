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

require 'rails_helper'

RSpec.describe Todo, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:items).dependent(:destroy)}
  # Validation test
  # ensure columns title and created_by are present befores saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
