require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # add todos owner
  let(:user) { create(:user) } 
  # initialize test data
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.first.id }
  # Authorize request
  let(:headers) { valid_headers } 
  # test suite for GET /todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get todos_path, headers: headers }
    
    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    #before { get todos_url(todo_id) }
    before { get todo_path(todo_id), params: {}, headers: headers }
    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      let(:todo_id) {100}
      it 'returns status code 404' do
        expect(response).to have_http_status(404)  
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /todos' do
    # Valid payload
    let(:valid_attributes) {{title: 'MakeJob', created_by: user.id.to_s}.to_json}
    context 'when the request is valid' do
      before { post todos_path, params: valid_attributes, headers: headers }
      it 'creates a todo' do
        expect(json['title']).to eq('MakeJob') 
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201) 
      end
    end

    context 'when the request is invalid' do
      before { post todos_path, params: {title: nil}.to_json, headers: headers }
      it 'returns status code 422' do
        expect(response).to have_http_status(422) 
      end
      it 'returns a validation failure message' do
        expect(json['message']).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    # Valid payload
    let(:valid_attributes) {{title: 'OtherJob'}.to_json}
    context 'when the request is valid' do
      before { put todo_path(todo_id), params: valid_attributes, headers: headers }
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204) 
      end
    end
  end

  # Test suite case DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete todo_path(todo_id), params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204) 
    end
  end
end