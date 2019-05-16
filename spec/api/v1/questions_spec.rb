describe 'Questions Api', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
   "ACCEPT" => 'application/json' } }

   describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

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
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question_s, 3) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:public_keys) { %w[id title body author_id created_at updated_at] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of question' do
        expect(json['questions'].size).to eq 3
      end

      it "return all public fields for objects" do
        public_keys.each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_json['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_json) { question_json['answers'].first }
        let(:public_keys) { %w[id body author_id created_at updated_at] }

        it 'returns list of question' do
          expect(question_json['answers'].size).to eq 3
        end

        it "return all public fields for objects" do
          public_keys.each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
