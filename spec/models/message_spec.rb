require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Message, type: :model do
  let(:customer) { Customer.create(name: 'John Doe', email: 'john.doe@example.com', phone: '+15555555555') }
  let(:message_template) do
    MessageTemplate.create(name: 'Welcome', content: 'Olá {{name}}', content_en: 'Hello {{name}} in English')
  end

  before do
    stub_request(:post, /api.twilio.com/).to_return(body: { sid: '12345', status: 'queued' }.to_json, status: 200)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      message = Message.new(customer: customer, content: 'Test message')
      expect(message).to be_valid
    end

    it 'is not valid without a customer' do
      message = Message.new(content: 'Test message')
      expect(message).not_to be_valid
    end

    it 'is not valid without content if message_template_id is nil' do
      message = Message.new(customer: customer)
      expect(message).not_to be_valid
    end

    it 'is valid with a message template' do
      message = Message.new(customer: customer, message_template: message_template)
      expect(message).to be_valid
    end

    it 'is not valid with an invalid message template' do
      message = Message.new(customer: customer, message_template_id: -1)
      expect(message).not_to be_valid
    end
  end

  describe 'callbacks' do
    context 'when sending a message' do
      it 'prepares the message content in English based on the template if phone starts with +1' do
        customer.update(phone: '+15555555555')
        message = Message.new(customer: customer, message_template: message_template)
        message.send(:prepare_message_content)
        expect(message.content).to eq('Hello John Doe in English')
      end

      it 'prepares the message content in the primary language based on the template if phone does not start with +1' do
        customer.update(phone: '+5511999999999')
        message = Message.new(customer: customer, message_template: message_template)
        message.send(:prepare_message_content)
        expect(message.content).to eq('Olá John Doe')
      end

      it 'blocks message if another message was sent within 24 hours' do
        Message.create(customer: customer, content: 'Previous message', sent_at: 1.hour.ago)
        message = Message.new(customer: customer, content: 'New message')
        expect(message.save).to be_falsey
        expect(message.errors[:base]).to include('Cannot send more than one message within 24 hours')
      end

      it 'allows message if bypass_check is set' do
        Message.create(customer: customer, content: 'Previous message', sent_at: 1.hour.ago)
        message = Message.new(customer: customer, content: 'New message', bypass_check: true)
        expect(message.save).to be_truthy
      end
    end
  end

  describe 'send_sms' do
    describe 'send_sms' do
      it 'sends an SMS using Twilio' do
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages,
                                                                             :create).and_return(double(error_code: nil))
        message = Message.new(customer: customer, content: 'Test message')
        expect { message.send(:send_sms) }.to change { message.sent_at }.from(nil)
      end

      it 'adds an error if SMS fails to send' do
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages,
                                                                             :create).and_return(double(error_code: '12345'))
        message = Message.new(customer: customer, content: 'Test message')
        expect do
          message.send(:send_sms)
        rescue StandardError
          nil
        end.to change { message.errors[:base].size }.by(1)
        expect(message.errors[:base]).to include('Failed to send SMS')
      end
    end
  end
end
