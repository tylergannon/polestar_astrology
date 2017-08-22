require_relative '20120325080018_create_jieqis'
require_relative '20120325081253_create_jieqi_dates'

class DropJieqiDates < ActiveRecord::Migration[5.0]
  def change
    revert CreateJieqiDates
    revert CreateJieqis
  end
end
