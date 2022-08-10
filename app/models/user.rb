class User < ApplicationRecord
  REQUIRE_EMAIL_CHANGE_PROVIDERS = ['twitter2'].freeze

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
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user unless authorization.nil?

    email = auth.info[:email]
    # set temporary email if not exist
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user_creation_params = if email
                               { email: email,
                                 password: password,
                                 password_confirmation: password,
                                 active: true }
                             else
                               { email: "#{Devise.friendly_token[0, 6]}@not-valid-email.com",
                                 password: password,
                                 password_confirmation: password,
                                 active: false }
                             end

      user = User.create!(user_creation_params)
    end
    user&.authorizations&.create(provider: auth.provider, uid: auth.uid)

    user
  end

  def active_for_authentication?
    providers = []
    authorizations.each { |a| providers << a.provider }
    # check if user provider not gives us email so we have to give user ability to change it and then activate user
    (providers & REQUIRE_EMAIL_CHANGE_PROVIDERS).any? && active == false ? true : super && active
  end

  def inactive_message
    'Sorry, this account has been deactivated.'
  end
end
