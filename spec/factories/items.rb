# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string
#  done       :boolean
#  todo_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.character }
    done { false }
    todo_id { nil }
  end
end
