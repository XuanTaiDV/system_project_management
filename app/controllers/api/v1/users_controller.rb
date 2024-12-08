
module Api
  module V1
    class UsersController < ApplicationController
      def register
        user = User.create!(permitted_params)

        render json: user
      end

      def login
        user = User.find_by(email: params[:email])

        raise Exceptions::Unauthorized unless user&.authenticate(params[:password])

        render json: { token: user.generate_token }
      end

      private

      def permitted_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
