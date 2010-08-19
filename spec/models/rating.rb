class Rating
  include Mongoid::Document

  field :score, :type => Integer

  validates_presence_of :ratable

  referenced_in :ratable, :polymorphic => true
  referenced_in :user
end
