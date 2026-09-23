require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should validate_presence_of :rfc }
  it { should have_many(:invoices).dependent(:destroy) }
end
