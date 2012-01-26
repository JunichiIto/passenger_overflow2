class Question < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :answers
  has_one :accepted_answer, class_name: "Answer", primary_key: "accepted_answer_id"

  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :content, :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'questions.created_at DESC'

  def accepted?
    self.accepted_answer
  end
end
