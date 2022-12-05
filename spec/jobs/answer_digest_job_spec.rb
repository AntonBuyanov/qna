require 'rails_helper'

RSpec.describe AnswerDigestJob, type: :job do
  let(:service) { double('AnswerDigest') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer,question_id: question.id, author_id: user.id) }

  before do
    allow(AnswerDigest).to receive(:new).and_return(service)
  end

  it 'calls AnswerDigest#send_digest' do
    expect(service).to receive(:send_digest)
    AnswerDigestJob.perform_now(answer)
  end
end
