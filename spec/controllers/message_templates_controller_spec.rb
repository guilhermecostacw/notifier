require 'rails_helper'

RSpec.describe MessageTemplatesController, type: :controller do
  let!(:message_template) { create(:message_template) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: message_template.to_param }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(message_template.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new MessageTemplate' do
        expect do
          post :create, params: { message_template: { name: 'Test Template', content: 'Hello, {{name}}' } }
        end.to change(MessageTemplate, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new MessageTemplate' do
        expect do
          post :create, params: { message_template: { name: '' } }
        end.to change(MessageTemplate, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Template' } }

      it 'updates the requested message_template' do
        put :update, params: { id: message_template.to_param, message_template: new_attributes }
        message_template.reload
        expect(message_template.name).to eq('Updated Template')
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        put :update, params: { id: message_template.to_param, message_template: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested message_template' do
      expect do
        delete :destroy, params: { id: message_template.to_param }
      end.to change(MessageTemplate, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
