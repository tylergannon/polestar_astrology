class CreateChartPalacesStars < ActiveRecord::Migration[5.0]
  def change
    create_table :chart_palaces_stars, id: false do |t|
      t.references :chart_palace, index: true
      t.references :star, index: true
    end

    # reversible do |direction|
    #   direction.up do
    #     ChartPalace.all.each do |chart_palace|
    #       print '#'
    #       # ming_location = chart_palace.chart.ming_id
    #
    #       chart_palace.stars = Star.all.select{|star|
    #         chart_palace.location_id == chart_palace.chart.send(star.symbol_name + "_id")
    #       }
    #     end
    #   end
    # end
  end
end
