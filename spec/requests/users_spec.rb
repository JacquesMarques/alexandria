require 'rails_helper'

RSpec.describe 'Users', type: :request do

  before do
    allow_any_instance_of(UsersController).to(
      receive(:validate_auth_scheme).and_return(true))
    allow_any_instance_of(UsersController).to(
      receive(:authenticate_client).and_return(true))
  end

  let(:john) { create(:user) }
  let(:users) { [john] }

  describe 'GET /api/users' do
    # Before any test, let's create our 3 users
    before { users }

    context 'default behavior' do
      before { get '/api/users' }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all users' do
        expect(json_body['data'].size).to eq 1
      end
    end

    describe 'field picking' do
      context 'with the fields parameter' do
        before { get '/api/users?fields=id,given_name,family_name' }

        it 'gets users with only the id, given_name and family_name keys' do
          json_body['data'].each do |user|
            expect(user.keys).to eq ['id', 'given_name', 'family_name']
          end
        end
      end

      context 'without the "fields" parameter' do
        before { get '/api/users' }

        it 'gets users with all the fields specified in the presenter' do
          json_body['data'].each do |user|
            expect(user.keys).to eq UserPresenter.build_attributes.map(&:to_s)
          end
        end
      end

      context 'with invalid field name "fid"' do
        before { get '/api/users?fields=fid,given_name,family_name' }

        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "fields=fid" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'fields=fid'
        end
      end # context "with invalid field name 'fid'" end
    end # End of describe 'field picking'

    describe 'pagination' do
      context 'when asking for the first page' do
        before { get('/api/users?page=1&per=1') }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only one user' do
          expect(json_body['data'].size).to eq 1
        end

      end

      context "when sending invalid 'page' and 'per' parameters" do
        before { get('/api/users?page=fake&per=10') }

        it 'receives HTTP status 400' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it "receives 'page=fake' as an invalid param" do
          expect(json_body['error']['invalid_params']).to eq 'page=fake'
        end
      end
    end # describe 'pagination' end

    describe 'sorting' do
      context 'with valid column name "id"' do
        it 'sorts the users by "id desc"' do
          get('/api/users?sort=id&dir=desc')
          expect(json_body['data'].first['id']).to eq john.id
        end
      end

      context 'with invalid column name "fid"' do
        before { get '/api/users?sort=fid&dir=asc' }

        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "sort=fid" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'sort=fid'
        end
      end
    end # describe 'sorting' end

    describe 'filtering' do
      context 'with valid filtering param "q[given_name_cont]=Microscope"' do
        it 'receives "Ruby under a microscope" back' do
          get('/api/users?q[given_name_cont]=John')
          expect(json_body['data'].first['id']).to eq john.id
          expect(json_body['data'].size).to eq 1
        end
      end

      context 'with invalid filtering param "q[fgiven_name_cont]=John"' do
        before { get('/api/users?q[fgiven_name_cont]=John') }

        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it 'receives "q[fgiven_name_cont]=John" as an invalid param' do
          expect(json_body['error']['invalid_params']).to eq 'q[fgiven_name_cont]=John'
        end
      end
    end  # describe 'filtering' end

  end

  describe 'GET /api/users/:id' do

    context 'with existing resource' do
      before { get "/api/users/#{john.id}" }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the "john" user as JSON' do
        expected = { data: UserPresenter.new(john, {}).fields.embeds }
        expect(response.body).to eq(expected.to_json)
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        get '/api/users/2314323'
        expect(response.status).to eq 404
      end
    end
  end # describe 'GET /api/users/:id'



  describe 'POST /api/users' do
    let(:user) { create(:michael_hartl) }
    before { post '/api/users', params: { data: params } }

    context 'with valid parameters' do
      let(:params) do
        attributes_for(:user)
      end

      it 'gets HTTP status 201' do
        expect(response.status).to eq 201
      end

      it 'receives the newly created resource' do
        expect(json_body['data']['given_name']).to eq 'John'
      end

      it 'adds a record in the database' do
        expect(User.count).to eq 1
      end

      it 'gets the new resource location in the Location header' do
        expect(response.headers['Location']).to eq(
                                                  "http://www.example.com/api/users/#{User.first.id}"
                                                )
      end
    end

    context 'with invalid parameters' do
      let(:params) { attributes_for(:michael_hartl, given_name: '') }

      it 'gets HTTP status 422' do
        expect(response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']['invalid_params']).to eq(
                                                          {
                                                           "email" => ["can't be blank", "is invalid"],
                                                           "password" => ["can't be blank", "can't be blank", "is too short (minimum is 8 characters)"]
                                                          },
                                                        )
      end

      it 'does not add a record in the database' do
        expect(Author.count).to eq 0
      end
    end # context 'with invalid parameters'
  end # describe 'POST /api/users'


  describe 'PATCH /api/users/:id' do
    before { patch "/api/users/#{john.id}", params: { data: params } }

    context 'with valid parameters' do
      let(:params) { { given_name: 'John' } }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the updated resource' do
        expect(json_body['data']['given_name']).to eq(
                                                     'John'
                                                   )
      end
      it 'updates the record in the database' do
        expect(User.first.given_name).to eq 'John'
      end
    end

    context 'with invalid parameters' do
      let(:params) { { email: '' } }

      it 'gets HTTP status 422' do
        expect(response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']['invalid_params']).to eq(
                                                          { "email"=>["can't be blank", "is invalid"] }
                                                        )
      end

      it 'does not add a record in the database' do
        expect(User.first.given_name).to eq 'John'
      end
    end
  end # describe 'PATCH /api/users/:id' end

  describe 'DELETE /api/users/:id' do
    context 'with existing resource' do
      before { delete "/api/users/#{john.id}" }

      it 'gets HTTP status 204' do
        expect(response.status).to eq 204
      end

      it 'deletes the book from the database' do
        expect(Author.count).to eq 0
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        delete '/api/users/2314323'
        expect(response.status).to eq 404
      end
    end
  end # describe 'DELETE /api/users/:id' end
end
