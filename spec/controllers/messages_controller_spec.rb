require 'rails_helper'
require 'webmock/rspec'
require 'prometheus_exporter'
require 'prometheus_exporter/client'

RSpec.describe MessagesController, type: :controller do
  let!(:customer) { create(:customer, phone: '+5511999999999') }
  let!(:message_template) { create(:message_template) }

  before do
    stub_request(:post, /api.twilio.com/)
      .to_return(status: 200, body: { sid: '12345',
                                      status: 'queued' }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:message, customer: customer, message_template: message_template)
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect do
          post :create, params: {
            message: {
              customer_id: customer.id,
              content: 'Hello, {{name}}',
              message_template_id: message_template.id,
              bypass_check: true
            }
          }
        end.to change(Message, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect do
          post :create, params: {
            message: {
              customer_id: nil,
              content: '',
              message_template_id: nil,
              bypass_check: true
            }
          }
        end.to change(Message, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
