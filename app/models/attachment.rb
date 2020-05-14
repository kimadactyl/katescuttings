class Attachment < ApplicationRecord
  belongs_to :blog
  has_one_attached :image
  validates :image, presence: :true
end
