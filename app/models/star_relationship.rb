class StarRelationship < ActiveRecord::Base
  belongs_to :palace
  # belongs_to :member, required: true

  has_many :star_relationship_stars, dependent: :destroy do
    def required
      where(required: true)
    end
    def optional
      where(required: false)
    end
  end

  def optional?(star)
    star.in? optional_stars
  end

  def required_stars
    @required_stars ||= star_relationship_stars.required.map(&:star)
  end

  def optional_stars
    @optional_stars ||= star_relationship_stars.optional.map(&:star)
  end

  def self.find_or_create(palace, *star_relationship_stars)
    star_relationship = StarRelationship.new palace: palace,
      star_relationship_stars: star_relationship_stars
    possible_matches(palace.id, star_relationship_stars.map(&:star_id)).
    find do |other|
      other =~ star_relationship
    end || StarRelationship.create(palace: palace).tap do |star_relationship|
      star_relationship.star_relationship_stars = star_relationship_stars
    end
  end

  has_many :stars, through: :star_relationship_stars
  has_many :comments, as: :commentable

  def =~(other)
    unless palace == other.palace
      false
    else
      star_relationship_stars.length == other.star_relationship_stars.length &&
      star_relationship_stars.all? do |star_relationship_star|
        other.star_relationship_stars.any? do |other_srs|
          star_relationship_star =~ other_srs
        end
      end
    end
  end

  def matches
    self.class.
    possible_matches(palace_id, stars.map(&:id)).
    where.not(
      star_relationships: {id: id}
    ).select do |relationship|
      relationship =~ self
    end
  end

  #  Returns true if chart palace has ALL required stars
  #  And either the relationship defined no optional stars
  #  Or at least one of the optional stars is present in the palace.
  def matches_chart_palace?(chart_palace)
    required_stars.all? do |required|
      required.in? chart_palace.stars
    end && (
      optional_stars.blank? ||
      optional_stars.any? do |optional|
        optional.in? chart_palace.stars
      end
    )
  end

  def self.find_by_chart_palace(chart_palace)
    possible = possible_matches(chart_palace.palace_id, chart_palace.stars.map(&:id))
    byebug
    possible.select do |star_relationship|
      star_relationship.matches_chart_palace?(chart_palace)
    end
  end

  def self.possible_matches(palace_id, star_ids)
    joins(
      star_relationship_stars: :star
    ).where(
      stars: {id: star_ids},
      star_relationships: {
        palace_id: palace_id
      }
    ).includes(:comments).distinct
  end

  def merge(others)
    others = [others].flatten
    others.each do |other|
      other.comments.update_all commentable_id: self.id
      other.destroy!
    end
  end
end
