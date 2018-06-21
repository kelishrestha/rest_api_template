# frozen_string_literal: true

FactoryGirl.define do
  factory :api_key do
    app_info { { app_name: 'rest_api_template' } }
    token Faker::Code.asin
  end
end
