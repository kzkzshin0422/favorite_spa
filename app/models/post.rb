class Post < ApplicationRecord

  belongs_to :user

  validates :facility_name, presence: true
  validates :service, presence: true
  validates :address, presence: true
  validates :star, presence: true

  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships , dependent: :destroy
  has_many :comments, dependent: :destroy

  def save_tags(tags)
    tags.each do |new_tags|
      self.tags.find_or_create_by(name: new_tags)
    end
  end

  def update_tags(latest_tags)
    if self.tags.empty?
      # 既存のタグがなかったら追加だけ行う
      latest_tags.each do |latest_tag|
        self.tags.find_or_create_by(name: latest_tag)
      end
    elsif latest_tags.empty?
      # 更新対象のタグがなかったら既存のタグをすべて削除
      # 既に保存がされていたら既に登録されているタグの内容を削除
      self.tags.each do |tag|
        self.tags.delete(tag)
      end
    else
      # 既存のタグも更新対象のタグもある場合は差分更新
      current_tags = self.tags.pluck(:name)
      #左を起点に引き算をする
      #　　　　　　 b             a b c
      old_tags = current_tags - latest_tags
      #一致したものを取り出す
      # a c       a b c            b
      new_tags = latest_tags - current_tags

      # a  c
      old_tags.each do |old_tag|
        tag = self.tags.find_by(name: old_tag)
        self.tags.delete(tag) if tag.present?
      end

      new_tags.each do |new_tag|
        # b
        self.tags.find_or_create_by(name: new_tag)
        # self.tags << new_tags
      end
    end
  end

  def self.search(search)
    return Post.all unless search
    Tag.where(['tag_name LIKE(?),"%#{search}%"'])
  end

end
