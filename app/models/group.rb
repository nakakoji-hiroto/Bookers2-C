class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users
  
  validates :name, presence: true
  validates :introduction, presence: true
  validates :mail_title, presence: true
  validates :mail_content, presence: true
  has_one_attached :group_image
  
  def is_owned_by?(user)
    owner.id == user.id
  end
  
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end
  
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end
end
