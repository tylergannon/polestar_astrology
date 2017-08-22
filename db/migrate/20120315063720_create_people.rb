class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.integer :member_id
      t.string :slug

      t.timestamps
    end
  end
end