class User < ApplicationRecord
  REQUIRE_EMAIL_CHANGE_PROVIDERS = ['twitter2'].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[twitter2 github]

  validates :email, presence: true

  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :comments, dependent: :destroy
  has_many :user_answer_votes, dependent: :destroy
  has_many :user_question_votes, dependent: :destroy
  has_many :update_question_notifications, dependent: :destroy

  after_save ThinkingSphinx::RealTime.callback_for(:user)

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user unless authorization.nil?

    email = auth.info[:email]
    # set temporary email if not exist
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user = if email
               User.new(email: email,
                        password: password,
                        password_confirmation: password)
             else
               User.new(unconfirmed_email: "#{Devise.friendly_token[0, 6]}@not-valid-email.com",
                        password: password,
                        password_confirmation: password)
             end
      user.skip_confirmation!
      user.save!(validate: false)
    end
    user&.authorizations&.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
