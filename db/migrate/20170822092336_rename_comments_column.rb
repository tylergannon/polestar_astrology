class RenameCommentsColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :comments, :comment_text
  end
end
