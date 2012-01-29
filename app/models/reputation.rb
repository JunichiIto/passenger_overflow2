class Reputation < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, polymorphic: true

  default_scope :order => 'reputations.created_at DESC'
end
