require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should validate_presence_of :name }
end
