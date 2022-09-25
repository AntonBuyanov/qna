require 'rails_helper'

RSpec.describe Answer, type: :model do
  it do
    should belong_to :question
  end

  it { should validate_presence_of :body }
end
