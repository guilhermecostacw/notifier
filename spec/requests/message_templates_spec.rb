require 'rails_helper'

RSpec.describe 'MessageTemplates', type: :request do
  describe 'GET /index' do
    it 'returns a success response' do
      get message_templates_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end
end
