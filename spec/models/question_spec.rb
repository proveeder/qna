require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect(Question.new(body: 'test body')).to_not be_valid
  end

  it 'validates presence of title' do
    expect(Question.new(title: 'text title')).to_not be_valid
  end
end
