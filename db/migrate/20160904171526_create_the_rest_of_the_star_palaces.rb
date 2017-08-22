class CreateTheRestOfTheStarPalaces < ActiveRecord::Migration[5.0]
  def change
    add_index :star_palaces, [:star_id, :palace_id]
    add_column :star_palaces, :with_star_id, :integer

    reversible do |direction|
      direction.up do
        for star in Star.all
          for palace in Palace.all
            StarPalace.find_or_create_by star_id: star.id, palace_id: palace.id
          end
        end
      end
    end

  end
end
