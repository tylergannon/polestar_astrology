class AddIndexMemberIdToCharts < ActiveRecord::Migration[5.0]
  def change
    add_index :charts, :member_id
  end
end
