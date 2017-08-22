class AddTimeZoneToCharts < ActiveRecord::Migration[5.0]
  def change
    add_column :charts, :time_zone, :string
  end
end
