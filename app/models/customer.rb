class Customer < ApplicationRecord
  has_many :messages
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email' }
  validates :phone, presence: true
  validate  :valid_phone_number

  def valid_phone_number
    return if phone.blank?

    return if phone.match?(/\A(\+55\d{11}|\+1\d{10})\z/)

    errors.add(:phone, 'must be a valid Brazilian (+55) or American (+1) phone number')
  end
end
