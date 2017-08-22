class AddCitationToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :citation, :string
  end
end
