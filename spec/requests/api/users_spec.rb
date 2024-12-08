# spec/requests/api/v1/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /api/v1/users/register' do
    context 'when the request is valid' do
      let(:valid_attributes) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user and returns the user as JSON' do
        post '/api/v1/users/register', params: valid_attributes

        # Expect a successful response (status 200 or 201, depending on how your controller is set up)
        expect(response).to have_http_status(:ok)

        # Expect the response body to include the user's attributes
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq('test@example.com')
        expect(json_response).not_to have_key('password')  # Ensure the password isn't included
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'wrongpassword'
          }
        }
      end

      it 'does not create a user and returns an error message' do
        post '/api/v1/users/register', params: invalid_attributes

        expect(response).to have_http_status(:bad_request)

        # Parse the response and check if error messages are included
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to include("Password confirmation doesn't match Password")
      end
    end
  end


  describe 'POST /api/v1/users/login' do
    let(:user) { double(User) }
    let(:valid_attributes) do
      {
        email: 'test@example.com',
        password: 'password123',
      }
    end


    context 'when the request is valid' do
      it 'creates a new user and returns the token' do
        allow(User).to receive(:find_by).with({email: valid_attributes[:email]}).and_return(user)
        allow(user).to receive(:authenticate).with(valid_attributes[:password]).and_return(true)
        allow(user).to receive(:generate_token)
        post '/api/v1/users/login', params: valid_attributes

        expect(response).to have_http_status(:ok)
        expect(user).to have_received(:generate_token).once
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) do
        {
          email: 'test@example.com',
          password: 'password123'
        }
      end

      it 'does not create a user and returns an error message' do
        post '/api/v1/users/login', params: invalid_attributes

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
