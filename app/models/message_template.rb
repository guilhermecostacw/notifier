class MessageTemplate < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true

  def fill_template(customer)
    content.gsub('{{name}}', customer.name)
           .gsub('{{phone}}', customer.phone)
           .gsub('{{email}}', customer.email)
  end

  def fill_template_en(customer)
    content_en.gsub('{{name}}', customer.name)
              .gsub('{{phone}}', customer.phone)
              .gsub('{{email}}', customer.email)
  end
end
