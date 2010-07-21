class Rating
  include Mongoid::Document

  field :score, :type => Integer

  validates_presence_of :ratable

  belongs_to_related :ratable, :polymorphic => true
end
