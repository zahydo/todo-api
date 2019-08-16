require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # test suite for GET /todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get todos_path }
    
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
    before { get todo_path(todo_id) }
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
    let(:valid_attributes) {{title: 'MakeJob', created_by: '1'}}
    context 'when the request is valid' do
      before { post todos_path, params: valid_attributes }
      it 'creates a todo' do
        expect(json['title']).to eq('MakeJob') 
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201) 
      end
    end

    context 'when the request is invalid' do
      before { post todos_path, params: {title: 'Other'} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422) 
      end
      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    # Valid payload
    let(:valid_attributes) {{title: 'OtherJob'}}
    context 'when the request is valid' do
      before { put todo_path(todo_id), params: valid_attributes }
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
    before { delete todo_path(todo_id) }

    it 'returns status code 204' do
      expect(response).to have_http_status(204) 
    end
  end
end