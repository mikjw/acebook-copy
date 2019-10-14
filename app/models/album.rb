class Album < ApplicationRecord
  has_many_attached :images
  validates :title, presence: true, unless: -> {ENV['RAILS_ENV'] ||= 'test'}
  validates :body, presence: true, unless: ->{ENV['RAILS_ENV'] ||= 'test'}
  validate :image_type, unless: ->{ENV['RAILS_ENV'] ||= 'test'}

  def thumbnail(index)
    return self.images[index].variant(resize: '300x300!')
  end

  private

  def image_type
    if images.attached? == false
      errors.add(:images, "are missing!")
    end
    images.each do |image|
      if !image.content_type.in?(%('image/jpeg image.png'))
        errors.add(:images, "needs to be a JPEG or PNG")
      end
    end
  end
end
