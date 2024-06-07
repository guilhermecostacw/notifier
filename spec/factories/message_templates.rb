FactoryBot.define do
  factory :message_template do
    name { 'Test Template' }
    content { 'Olá, {{name}}' }
    content_en { 'Hello, {{first_name}}' }
  end
end
