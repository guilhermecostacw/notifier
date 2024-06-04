require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'is valid with valid attributes' do
    customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '+15555555555')
    expect(customer).to be_valid
  end

  it 'is not valid without a name' do
    customer = Customer.new(email: 'john.doe@example.com', phone: '+15555555555')
    expect(customer).not_to be_valid
  end

  it 'is not valid with an invalid email' do
    customer = Customer.new(name: 'John Doe', email: 'john.doe', phone: '+15555555555')
    expect(customer).not_to be_valid
  end

  it 'is not valid with an invalid phone number' do
    customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '+99999999999')
    expect(customer).not_to be_valid
  end

  it 'is not valid with a phone number that is not Brazilian or American' do
    customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '+449999999999')
    expect(customer).not_to be_valid
  end
end
