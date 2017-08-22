class SetRequiredTrue < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up do
        StarRelationshipStar.where(required: nil).update_all required: true
      end
    end
  end
end
