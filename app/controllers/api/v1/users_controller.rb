# frozen_string_literal: true

module Api
  module V1
    # Users controller
    class UsersController < BaseController
      before_action :validate_schema, except: [:show, :destroy]

      def create
        user = CreateUser.new(create_params).call
        render json: user, status: 200
      end

      private

      def create_params
        params.permit(:first_name, :last_name, :age, :married, :dob, :image, :email)
      end
    end
  end
end
