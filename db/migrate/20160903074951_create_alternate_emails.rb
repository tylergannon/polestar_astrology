class CreateAlternateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :alternate_emails do |t|
      t.string :email
      t.references :member, foreign_key: true

      t.timestamps
    end
    Member.find_by_email('tgannon@gmail.com')&.alternate_emails&.create email: 'tyler@aprilseven.co'
  end
end
