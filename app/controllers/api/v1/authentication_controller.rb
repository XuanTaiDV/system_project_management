module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authenticate!

      private

      def authenticate!
        token = request.headers['Authorization'].split(' ').last
        raise Exceptions::Unauthorized, 'Token missing' if token.blank?
        begin
          decoded_data, _ = decode_token!(token)
          @current_user = find_user(decoded_data)
        rescue JWT::DecodeError => e
          raise Exceptions::Unauthorized, 'Invalid token'
        end
      end

      def decode_token!(token)
        AuthToken.decode!(token)
      end

      def find_user(decoded_data)
        User.find_by(id: decoded_data['user_id']) || (raise Exceptions::Unauthorized)
      end

      def current_user
        @current_user
      end
    end
  end
end
