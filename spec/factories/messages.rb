FactoryBot.define do
  factory :message do
    customer
    content { 'Hello' }
    message_template
  end
end
