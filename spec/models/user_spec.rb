require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }
  it { should have_many(:comments).dependent(:destroy) }
end
