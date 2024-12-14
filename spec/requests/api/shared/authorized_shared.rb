RSpec.shared_context 'authorization' do
  let!(:user) { FactoryBot.create(:user) }
  let(:decode_token) { { 'user_id': 1 } }
  let(:headers) {{ "Authorization": "Bearer token" }}
  before do
    allow(AuthToken).to receive(:decode!).and_return([decode_token, {}])
    allow(User).to receive(:find_by).with(id: decode_token['user_id']).and_return(user)
  end
end