# frozen_string_literal: true
# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint(8)        not null, primary key
#  app_info   :json             not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Api Key model
class ApiKey < ApplicationRecord
  before_create -> { assign_unique_id(field: :token) }

  def self.valid_token?(token)
    ApiKey.exists?(token: token)
  end
end
