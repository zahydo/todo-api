require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # create test user
  let!(:user) { create(:user) } 
  # set headers for authorization
  let(:headers) { { 'Authorization' => token_generator(user.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe "#authorize_request" do
    context "when auth token is passed" do
      before { allow(request).to receive(:headers).and_return(headers) }

      # private method autorize_request returns current_user
      it "sets the current user" do
        # subject.instance_eval {authorize_request} --> invoke the private method
        expect(subject.instance_eval {authorize_request}).to eq(user)
      end      
    end
    
    context "when auth token is not passed" do
      before { allow(request).to receive(:headers).and_return(invalid_headers) }
      it "raises MissingToken error" do
        expect{subject.instance_eval {authorize_request}}.to raise_error(ExceptionHandler::MissingToken, /Missing token/)
      end
    end
  end
end
