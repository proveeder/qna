require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for regular user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    # able to update self-created question
    it { should be_able_to :update, create(:question, user: user), user: user }
    # unable to update other's question
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :set_best_answer, create(:question, user: user), user: user }

    it { should be_able_to :vote_for_question, create(:question), user: user }

    it { should be_able_to :vote_for_answer, create(:answer, user: other_user), user: user }
    it { should_not be_able_to :vote_for_answer, create(:answer, user: user), user: user }
  end
end
