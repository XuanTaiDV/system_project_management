# spec/requests/api/v1/users_spec.rb
require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:decode_token) { { 'user_id': 1 } }
  let(:headers) {{ "Authorization": "Bearer token" }}
  before do
    allow(AuthToken).to receive(:decode!).and_return([decode_token, {}])
    allow(User).to receive(:find_by).with(id: decode_token['user_id']).and_return(user)
  end

  describe 'GET /api/v1/projects' do
    let(:endpoint) { '/api/v1/projects' }
    before do
      3.times.each do |i|
        FactoryBot.create(:project, user_id: user.id, name: "project#{i}")
      end
    end

    context 'Get project successfully' do
      it 'should return list projects' do
        get endpoint, headers: headers
        binding.pry
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
