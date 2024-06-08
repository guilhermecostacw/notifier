require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET /index' do
    it 'returns a success response' do
      get customers_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end
end
