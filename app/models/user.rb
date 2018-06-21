# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  uid        :string
#  first_name :string
#  last_name  :string
#  image      :string
#  dob        :datetime
#  age        :integer
#  married    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  before_create -> { assign_unique_id(field: :uid) }
end
