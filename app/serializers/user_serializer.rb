# frozen_string_literal: true
# Generate user representation
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :dob, :image, :married, :age, :email

  def id
    object.uid
  end

  def name
    object.first_name + ' ' + object.last_name
  end

  def dob
    object.dob.utc.iso8601
  end
end
