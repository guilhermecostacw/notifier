class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :message_template, optional: true

  before_create :check_recent_messages, :prepare_message_content, :send_sms

  attr_accessor :bypass_check

  private

  def send_sms
    Message.transaction do
      client = Twilio::REST::Client.new(
        Rails.application.credentials.twilio[:account_sid],
        Rails.application.credentials.twilio[:auth_token]
      )

      body_content = content

      # Send message using Twillio
      response = client.messages.create(
        from: Rails.application.credentials.twilio[:phone_number],
        to: customer.phone,
        body: body_content
      )

      # Verify if message was sent
      if response.error_code.nil?
        self.sent_at = Time.current
      else
        errors.add(:base, 'Failed to send SMS')
        throw(:abort)
      end
    end
  end

  # Prepares the content of the message by filling in the message template with customer data.
  def prepare_message_content
    return unless message_template

    self.content = message_template.fill_template(customer)
  end

  # Checks if there are any recent messages sent by the customer.
  # If a message was sent within the last 24 hours, it raises an error.
  def check_recent_messages
    return if bypass_check

    last_message = Message.where(customer: customer).order(sent_at: :desc).first
    return unless last_message && last_message.sent_at > 24.hours.ago

    errors.add(:base, 'Cannot send more than one message within 24 hours')
    throw(:abort)
  end
end
