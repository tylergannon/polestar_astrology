class Member < ActiveRecord::Base
  # Include default devise modules. Others available are::confirmable,
  # :token_authenticatable, :lockable, :timeoutable and :omniauthable, :registerable,
  devise :database_authenticatable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  # has_many :people
  has_many :alternate_emails, dependent: :delete_all
  has_many :charts, dependent: :destroy

  def full_name
    if first_name?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  EMAIL_QUERY = <<-EOQ
    SELECT members.*
    FROM members LEFT OUTER JOIN
      alternate_emails
        ON members.id = alternate_emails.member_id
    WHERE members.email = ?
      OR alternate_emails.email = ?
  EOQ

  def self.find_by_email(email)
    find_by_sql([EMAIL_QUERY, email, email]).first
  end

end
