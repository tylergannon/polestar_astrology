class StarRelationshipStar < ActiveRecord::Base
  belongs_to :star_relationship, required: true
  belongs_to :star, required: true

  default_value_for :required, true

  def =~(other)
    star_id == other.star_id && required == other.required
  end
end
