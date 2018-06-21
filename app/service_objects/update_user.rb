# frozen_string_literal: true

# Update User
class UpdateUser
  attr_reader :user_params
  attr_accessor :user

  def initialize(user, user_params)
    @user = user
    @user_params = user_params
  end

  def call
    update_user
    user
  end

  private

  def update_user
    user.update(user_params)
  end
end
