require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'sends daily digest' do
    DailyDigestJob.perform_now
  end
end
