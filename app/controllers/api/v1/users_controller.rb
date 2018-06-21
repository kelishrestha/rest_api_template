# frozen_string_literal: true

module Api
  module V1
    # Users controller
    class UsersController < BaseController
      before_action :validate_schema, except: [:show, :destroy, :index]
      before_action :find_user, except: [:create, :index]

      def create
        user = CreateUser.new(create_params).call
        render json: user, status: 201
      end

      def show
        render json: @user, status: 200
      end

      def index
        users = User.all
        render json: users, status: 200
      end

      def update
        user = UpdateUser.new(@user, update_params).call
        render json: user, status: 200
      end

      def destroy
        api_error(500) unless @user.destroy!
        head :no_content
      end

      private

      def create_params
        params.permit(:first_name, :last_name, :age, :married, :dob, :image, :email)
      end

      def user_params
        params.permit(:uid)
      end

      def update_params
        params.permit(:first_name, :last_name, :age, :married, :image, :email)
      end

      def find_user
        @user = User.find_by(uid: user_params[:uid])
        api_error(404, 'user not found') unless @user
      end
    end
  end
end
