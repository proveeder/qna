class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter2 github]

  validates :email, presence: true
  validates :password, presence: true

  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :comments, dependent: :destroy

  def self.find_for_oauth(auth)
    p 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user unless authorization.nil?

    email = auth.info[:email] || Devise.friendly_token[0, 6] + '@not-valid-email.com'
    # set temporary email if not exist
    user = User.find_by(email: email)
    unless user
      p 'UNLESS'
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email,
                          password: password,
                          password_confirmation: password,
                          active: false)
    end
    p 'USER'
    p user
    user&.authorizations&.create(provider: auth.provider, uid: auth.uid)

    user
  end

  def active_for_authentication?
    # super && self.active
    true
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end
end
