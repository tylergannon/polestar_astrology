class MoveStarPalacesToStarRelationships < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up do
        StarPalace.all.each do |star_palace|
          comments = star_palace.comments
          comment = star_palace.comments.first
          if comment
            relationship = StarRelationship.create member_id: comment.member_id,
              palace: star_palace.palace
            relationship.star_relationship_stars.create! star: star_palace.star
            star_palace.comments.update_all commentable_type: 'StarRelationship',
              commentable_id: relationship.id
          end

        end

        ids = StarRelationship.ids
        while id = ids.shift
          if relationship = StarRelationship.find_by(id: id)
            puts relationship.inspect
            relationship.merge(relationship.matches)
          end
        end
      end

      direction.down do
        StarPalace.all.each do |star_palace|
          comments = star_palace.comments
          comment = star_palace.comments.first
          if comment
            relationship = StarRelationship.create member_id: comment.member_id,
              palace: star_palace.palace
            relationship.star_relationship_stars.create! star: star_palace.star
          end
        end
      end
    end
  end
end
