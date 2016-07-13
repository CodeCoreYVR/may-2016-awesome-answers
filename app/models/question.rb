class Question < ActiveRecord::Base
  attr_accessor :tweet_it

  # has_many helps us set up the association between question model and the
  # answer model. In this case `has_many` assumes that the answers table contain
  # a field named `question_id` that is an integer (this is a Rails convention).
  # the dependent option takes valus like `destroy` and `nullify`
  # `destroy` will make Rails automatically delete associated answers before
  # deleting the question.
  # `nullify` will make Rails turn `question_id` values of associated records
  # to `NULL` before deleting the question.
  has_many :answers, dependent: :destroy
  belongs_to :category
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates(:title, {presence: {message: "must be present!"}, uniqueness: true})

  # by having the option: uniqueness: {scope: :title} it ensures that the body
  # must be unique in combination with the title.
  validates :body, presence:   true,
                   length:     {minimum: 7},
                   uniqueness: {scope: :title}

  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  # VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, format: VALID_EMAIL_REGEX

  validate :no_monkey
  validate :no_title_in_body

  after_initialize  :set_defaults
  before_validation :cap_title, :squeeze_title_and_body

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  mount_uploader :image, ImageUploader

  # scope :recent, lambda {|count| where("created_at > ?", 3.day.ago).limit(count) }
  def self.recent(count)
    where("created_at > ?", 3.day.ago).limit(count)
  end

  # scope :search, lambda {|word| where("title ILIKE ? OR body ILIKE ?", "%#{word}%", "%#{word}%")}
  def self.search(word)
    where("title ILIKE :word OR body ILIKE :word", {word: "%#{word}%"})
  end

  def new_first_answers
    answers.order(created_at: :desc)
  end

  def liked_by?(user)
    # likes.find_by_user_id user
    likes.exists?(user: user)
  end

  def like_for(user)
    likes.find_by_user_id user
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def vote_for(user)
    votes.find_by_user_id user
  end

  def voted_up_by?(user)
    voted_by?(user) && vote_for(user).is_up?
  end

  def voted_down_by?(user)
    voted_by?(user) && !vote_for(user).is_up?
  end

  def up_votes
    votes.where(is_up: true).count
  end

  def down_votes
    votes.where(is_up: false).count
  end

  def vote_sum
    up_votes - down_votes
  end

  # def to_param
  #   "#{id}-#{title}".parameterize
  # end

  # delegate :name, to: :category, prefix: true
  def category_name
    category.name
  end

  delegate :first_name, :last_name, to: :user, prefix: true

  private

  def cap_title
    self.title = title.capitalize if title
  end

  def squeeze_title_and_body
    self.title.squeeze!(" ") if title
    self.body.squeeze!(" ") if body
  end

  def set_defaults
    self.view_count ||= 0
  end

  def no_monkey
    if title && title.downcase.include?("monkey")
      errors.add(:title, "No monkey please!")
    end
  end

  def no_title_in_body
    if body && body.include?(title)
      errors.add(:body, "No title in my body please!")
    end
  end

end
