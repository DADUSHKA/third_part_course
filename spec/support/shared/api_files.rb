shared_examples_for 'API files' do
  include Rails.application.routes.url_helpers
   context 'files' do
    let(:file) { object.files.first.blob }
    let(:files_response) { object_response['files'] }
    let(:file_response) { files_response.first }
    let(:public_keys) { %w[id filename] }

    it 'rerurn list of files' do
      expect(files_response.size).to eq object.files.size
    end

    it 'returns all public fields' do
      public_keys.each do |attr|
        expect(file_response[attr]).to eq file.send(attr).as_json
      end
    end
  end
end
