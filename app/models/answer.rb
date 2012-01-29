class Answer < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :question
  has_many :votes
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :question_id, :presence => true

  default_scope :order => 'answers.created_at DESC'
end
