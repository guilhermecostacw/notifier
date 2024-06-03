require 'rails_helper'

RSpec.describe MessageTemplate, type: :model do
  describe '#fill_template' do
    let(:customer) { Customer.new(name: 'John Doe', phone: '1234567890', email: 'john.doe@example.com') }
    let(:message_template) do
      MessageTemplate.new(content: 'Hello {{name}}, your phone number is {{phone}} and your email is {{email}}.')
    end

    it 'replaces placeholders with customer data' do
      filled_template = message_template.fill_template(customer)
      expect(filled_template).to eq('Hello John Doe, your phone number is 1234567890 and your email is john.doe@example.com.')
    end

    it 'does not modify the original template' do
      original_template = message_template.content.dup
      message_template.fill_template(customer)
      expect(message_template.content).to eq(original_template)
    end
  end
end
