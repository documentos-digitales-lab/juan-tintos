class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy

  validates :rfc, presence: true
end