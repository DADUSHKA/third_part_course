shared_examples_for 'API comments' do
  context 'comments' do
    let(:comment) { comments.last }
    let(:json_comments) { object_response['comments'] }
    let(:json_comment) { json_comments.first }
    let(:keys) { %w[id body user_id commentable_type commentable_id] }

    it "returns list of objects" do
      expect(json_comments.size).to eq 3
    end

    it "return all public fields for objects" do
      keys.each do |attr|
        expect(json_comment[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
