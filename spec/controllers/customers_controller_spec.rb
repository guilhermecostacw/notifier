require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let!(:customer) { create(:customer) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).length).to eq(Customer.count)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: customer.to_param }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(customer.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { name: 'Jane Doe', phone: '+15555555555', email: 'jane.doe@example.com' } }

      it 'creates a new Customer' do
        expect do
          post :create, params: { customer: valid_attributes }
        end.to change(Customer, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('Jane Doe')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', phone: 'invalid', email: '' } }

      it 'does not create a new Customer' do
        expect do
          post :create, params: { customer: invalid_attributes }
        end.to change(Customer, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("Name can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'John Updated', phone: '+15555555555', email: 'john.updated@example.com' } }

      it 'updates the requested customer' do
        put :update, params: { id: customer.to_param, customer: new_attributes }
        customer.reload
        expect(customer.name).to eq('John Updated')
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', phone: 'invalid', email: '' } }

      it 'returns an unprocessable entity response' do
        put :update, params: { id: customer.to_param, customer: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      expect do
        delete :destroy, params: { id: customer.to_param }
      end.to change(Customer, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
