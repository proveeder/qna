# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment, UpdateQuestionNotification]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Attachment], user: @user
    # TODO: refactor model
    can :destroy, UpdateQuestionNotification, user_id: @user.id

    can :set_best_answer, Question, user: @user

    can :vote_for_answer, Answer
    cannot :vote_for_answer, Answer, user: @user
    can :vote_for_question, Question
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end
end
