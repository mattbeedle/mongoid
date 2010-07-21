class Movie
  include Mongoid::Document

  field :name

  has_many_related :ratings, :as => :ratable
end
