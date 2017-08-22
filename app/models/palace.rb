class Palace < ActiveRecord::Base
  extend FriendlyId
  friendly_id :fix_name, use: [:finders, :slugged]

  has_many :star_relationships do
    def by_member(member)
      where(member_id: member.id)
    end
  end

  def fix_name
    name.underscore.gsub(/\//, '-')
  end

  def self.reseed
    destroy_all
    NAMES.each_with_index do |name, index|
      palace = Palace.create! name: name, ordinal: (index+1), id: (index+1)

    end
  end

  def self.find_by_friendly!(name)
    friendly.find name
  end

  def self.find_by_ordinal(i)
    Rails.cache.fetch "palace=#{i}" do
      find_by ordinal: i
    end
  end

  NAMES = %w(
    Ming
    Youth/Siblings
    Partner/Spouse
    Children
    Wealth
    Health
    Career/Travel
    Assistants
    Superiors
    Property
    Pleasure
    Ancestors
  )
end
