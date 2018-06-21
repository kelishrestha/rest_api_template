# frozen_string_literal: true

# Create User
class CreateUser
  attr_reader :user_params

  def initialize(user_params)
    @user_params = user_params
  end

  def call
    create_user
  end

  private

  def create_user
    User.create(user_params)
  end
end
