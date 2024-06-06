class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :message_template, optional: true

  before_create :check_recent_messages, :prepare_message_content, :send_sms
  after_create :increment_message_counter

  attr_accessor :bypass_check

  # The message content can be either a custom message or a message template.
  validates :customer, presence: true
  validates :content, presence: true, if: -> { message_template_id.nil? }
  validate :valid_message_template, if: -> { message_template_id.present? }

  private

  def valid_message_template
    return if MessageTemplate.exists?(id: message_template_id)

    errors.add(:message_template, 'is not valid')
  end

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

  def prepare_message_content
    return unless message_template

    self.content = select_template_content
  end

  # Select the template content based on the customer's phone number and the template's language.
  def select_template_content
    if customer.phone.start_with?('+1') && message_template.content_en.present?
      message_template.fill_template_en(customer)
    else
      message_template.fill_template(customer)
    end
  end

  # Check if the customer has sent a message in the last 24 hours.
  def check_recent_messages
    return if bypass_check

    last_message = Message.where(customer: customer).order(sent_at: :desc).first
    return unless last_message && last_message.sent_at > 24.hours.ago

    errors.add(:base, 'Cannot send more than one message within 24 hours')
    throw(:abort)
  end

  # Prometheus metric to count the number of messages sent.
  def increment_message_counter
    client = PrometheusExporter::Client.default
    client.send_json(
      type: 'counter',
      name: 'sent_messages',
      help: 'Total number of messages sent',
      value: 1,
      custom_labels: { service: 'notifier' }
    )
  end
end
