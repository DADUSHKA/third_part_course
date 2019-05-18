shared_examples_for 'API links' do
  context 'links' do
    let(:link) { links.last }
    let(:json_links) { object_response['links'] }
    let(:json_link) { json_links.first }
    let(:keys) { %w[name url] }

    it "returns list of objects" do
      expect(json_links.size).to eq 2
    end

    it "return all public fields for objects" do
      keys.each do |attr|
        expect(json_link[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
