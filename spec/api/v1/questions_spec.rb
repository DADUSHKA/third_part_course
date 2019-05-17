describe 'Questions Api', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
   "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let!(:questions) { create_list(:question_s, 3, author: me) }
  let(:question) { questions.first }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

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
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:public_keys) { %w[id title body author_id created_at updated_at] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

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

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

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
      let!(:question) { create(:question, :with_file) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let(:comment) { comments.first }
      let(:question_response) { json['question'] }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { question.links.order(created_at: :desc).first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 OK status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      context 'comments' do
        let(:comment) { comments.last }
        let(:json_comments) { question_response['comments'] }
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

      context 'links' do
        let(:link) { links.last }
        let(:json_links) { question_response['links'] }
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

      context 'files' do
        let(:file) { question.files.first.blob }
        let(:files_response) { question_response['files'] }
        let(:file_response) { files_response.first }

        it 'rerurn list of files' do
          expect(files_response.size).to eq question.files.size
        end

        it 'returns all public fields' do
          %w[id filename].each do |attr|
            expect(file_response[attr]).to eq file.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:headers) { nil }

    context 'unauthorithed' do
      it 'returns 401 status if there is no access_token' do
        post api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { post api_path, params: { question: attributes_for(:question), access_token: access_token.token } }

        it 'save new question' do
          expect { send_request }.to change(Question, :count).by(1)
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end

        it 'question has association with user' do
          send_request
          expect(Question.last.author_id).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token } }

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Question, :count)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { nil }

    context 'unauthorithed' do
      it 'returns 401 status if there is no access_token' do
        patch api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          patch api_path,
          params: {
            id: question,
            question: attributes_for(:question),
            access_token: access_token.token,
            format: :json
          }
        end

        it 'assigns the requested question to @question' do
          send_request
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          send_request
          question.reload

          expect(question.title).to eq 'MyQuestion'
          expect(question.body).to eq 'MyText'
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) do
          patch api_path,
          params: {
            id: question,
            question: attributes_for(:question, :invalid),
            access_token: access_token.token
          }
        end

        it 'does not update question' do
          title = question.title
          body = question.body
          send_bad_request
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { nil }

    context 'unauthorithed' do
      it 'returns 401 status if there is no access_token' do
        delete api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { delete api_path, params: { id: question, access_token: access_token.token } }

        it 'delete the question' do
          expect { send_request }.to change(Question, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end
