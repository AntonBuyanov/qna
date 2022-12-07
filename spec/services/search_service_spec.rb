require 'rails_helper'

RSpec.describe SearchService do
  it 'Method call' do
    SearchService.new(request: 'search text', type: 'Question').call
  end
end
