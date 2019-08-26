require 'rails_helper'

RSpec.describe "Items API", type: :request do
  # Initialize the test data
  let(:user) { create(:user) } 
  let!(:todo) { create(:todo, created_by: user.id) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id)}
  let(:todo_id) { todo.id }
  let(:item_id) { items.first.id }
  let(:headers) { valid_headers } 

  # Test suite for GET /todos/:todo_id/items
  describe "GET /todos/:todo_id/items" do
    before { get todo_items_path(todo_id), params: {}, headers: headers }
    context "when todo exists" do
      it "returns status code 200" do
        expect(response).to  have_http_status(200)
      end

      it "returns all todo items" do
        expect(json.size).to eq(20)
      end
    end
    context "when todo does not exists" do
      let(:todo_id) { 0 } 
      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end
  
  # test suit for GET /todos/:todo_id/items/:id
  describe "GET /todos/:todo_id/items/:id" do
    before { get todo_item_path(todo_id, item_id), params: {}, headers: headers }

    context "when the item exists" do
      it "returns status code 200" do
        expect(response).to have_http_status(200) 
      end

      it "returns the item" do
        expect(json['id']).to eq(item_id) 
      end
    end

    context "when the item does not exists" do
      let(:item_id) { 0 }
      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # test suite for POST /todos/:todo_id/items
  describe "POST /todos/:todo_id/items" do
    let(:valid_attributes) { { name: 'Make the force', done: false }.to_json } 
    context "when request attributes are valid" do
      before { post todo_items_path(todo_id), params: valid_attributes, headers: headers }
      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request attributes are not valid" do
      before { post todo_items_path(todo_id), params: {}, headers: headers}
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # test suite for PUT /todos/:todo_id/items/:id
  describe "PUT /todos/:todo_id/items/:id" do
    let(:valid_attributes) {{name: 'Anakin'}.to_json}
    before { put todo_item_path(todo_id, item_id), params: valid_attributes, headers: headers }
    context "when item exists" do
      it "returns status code 204" do
        expect(response).to have_http_status(204)  
      end
      it "updates the item" do
        updated_item = Item.find(item_id)
        expect(updated_item.name).to match(/Anakin/)         
      end
    end

    context "when the item does not exists" do
      let(:item_id) {0}
      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Item/) 
      end
    end
  end

  # test suite for DELETE /todos/:todo_id/items/:id
  describe "DELETE /todos/:todo_id/items/:id" do
    before { delete todo_item_path(todo_id, item_id), params: {}, headers: headers }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end
  end
end
