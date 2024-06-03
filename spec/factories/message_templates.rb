FactoryBot.define do
  factory :message_template do
    name { 'Welcome Template' }
    content { 'Hello {{name}}, welcome to our service!' }
  end
end
