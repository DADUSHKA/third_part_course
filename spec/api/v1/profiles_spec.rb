describe 'Profiles Api', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
   "ACCEPT" => 'application/json' } }

   describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    context 'unauthorithed' do
      it 'returns 401 status if there is no access_token' do
        get api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:public_keys) { %w[id email admin created_at updated_at] }
      let(:private_keys) { %w[password encrypted_password] }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it "return all public fields for objects" do
        public_keys.each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it "does not return private fields" do
        private_keys.each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'get /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    context 'unauthorithed' do
      it 'returns 401 status if there is no access_token' do
        get api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:keys) { %w[id email admin created_at updated_at] }
      let(:json_users) { json['users'] }
      let(:json_user) { json_users.first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of object' do
        expect(json_users.size).to eq 2
      end

      it "return all public fields for objects" do
        keys.each do |attr|
          expect(json_user[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'not return authenticated user' do
        json_users.each do |user|
          expect(user['id']).to_not eq me.id.as_json
        end
      end
    end
  end
end
