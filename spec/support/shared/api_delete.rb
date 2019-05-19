shared_examples_for 'API Deletable' do
  context 'authorized' do
    context 'with valid attributes' do
      let(:send_request) { do_request(method, api_path, params: { id: resource, access_token: access_token.token }) }

      it 'delete the question' do
        expect { send_request }.to change(resource.class, :count).by(-1)
      end

      it 'status success' do
        send_request
        expect(response.status).to eq 204
      end
    end
  end
end
