require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # create test user
  let(:user) { create(:user) }
  # Mock 'Authorization' header
  let(:headers) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({}) }
  # Valid request subject
  subject(:request_obj) { described_class.new(headers) }
  
  # Test suite for AuthorizeApiRequest#call
  # this is the entry point into the service class
  describe "#call" do
    # returns user object when request is valid
    context "when valid request" do
      it "returns user object" do
        result = request_obj.call
        expect(result[:user]).to eq(user)  
      end
    end

    context "when invalid request" do
      context "when missing token" do
        it "raises a MissingToken error" do
          expect {invalid_request_obj.call}.to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end
      context "when invalid token" do
        # custom helper method 'token_generator'
        subject(:invalid_request_obj) { described_class.new('Authorization' => token_generator(100)) } 

        it "raises an InvalidToken error" do
          expect {invalid_request_obj.call}.to raise_error(ExceptionHandler::InvalidToken, /Invalid token Couldn't find User with 'id'=100/)
        end
      end
      context "when token is expired" do
        # custom helper method 'expired_token_generator'
        let(:headers) { {'Authorization' => expired_token_generator(user.id)} }
        subject(:request_obj) { described_class.new(headers) }

        it "raises ExceptionHandler::ExpiredSignature error" do
          expect {request_obj.call}.to raise_error(ExceptionHandler::InvalidToken, 'Signature has expired')
        end
      end
      context "when fake token" do
        let(:headers) { {'Authorization' => 'Something' } }
        subject(:invalid_request_obj) { described_class.new(headers) }

        it "handles JWT::DecodeError" do
          expect {invalid_request_obj.call}.to raise_error(ExceptionHandler::InvalidToken, 'Not enough or too many segments')          
        end
      end
    end
  end
end