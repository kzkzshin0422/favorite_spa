class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  validates :profile_image, presence: true, on: :update
  #validates :profile, presence: true, on: :update
  validates :nickname, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.first_name = ""
      user.last_name = ""
      user.first_name_kana = ""
      user.last_name_kana = ""
      user.profile = ""
      user.nickname = "guestuser"
      user.birth_date = "2019/02/24"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

end
