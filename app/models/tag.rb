class Tag < ApplicationRecord

  has_many :tag_relationships, dependent: :destroy
  has_many :posts, through: :tag_relationships

  def self.search(search)
    return Post.all unless search
    @tags = Tag.where("name LIKE?","%#{search}%")
    @tags.each do |tag|
      @posts = tag.posts
    end
   return @posts
  end
end
