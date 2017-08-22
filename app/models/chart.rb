class Chart < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :member, touch: true

  before_validation :build_chart!
  validates :zi_wei_id, presence: true

  #  Branch assignments for palaces are in reverse order
  #  beginning with the branch of the Ming palace.
  def palaces
    Rails.cache.fetch "#{cache_key}/palaces" do
      branches = Branch.all.to_a.rotate(ming_id).reverse

      Palace.all.zip(branches).map do |palace, branch|
        ChartPalace.new palace: palace, location: branch, stars: stars_in_branch_palace(branch)
      end
    end
  end

  def stars_in_branch_palace(branch)
    Star.all.select do |star|
      self["#{star.symbol_name}_id"] == branch.id
    end
  end

  def build_chart!
    lunar_date = LunarDate.from_solar_date(solar_date)
    self.attributes = lunar_date.stored_attributes
    self.attributes = ChartBuilder.new(self).attributes
  end

  concerning :DateCorrection do
    def dst?
      if time_zone?
        dob.in_time_zone.dst?
      else
        false
      end
    end

    def local_dob
      if time_zone?
        dob.in_time_zone(time_zone)
      else
        dob
      end
    end

    def corrected_dob
      if time_zone?
        d = dob.in_time_zone(time_zone)
        if d.dst?
          d = d - 1.hours
        end
        d
      else
        dob
      end
    end

    def solar_date
      date = corrected_dob
      if date.hour == 0
        hour = 0
      elsif date.hour == 23
        hour = 23
      elsif date.hour % 2 == 0
        hour = date.hour - 1
      else
        hour = date.hour
      end
      DateTime.parse(date.strftime("%Y-%m-%d #{hour}:00"))
    end
  end

  concerning :DisplayProperties do
    def person_name
      "#{first_name} #{last_name}"
    end

    def search_text
      "#{person_name} #{year.stem.element} #{year.branch.animal} #{hour.stem.element} #{hour.branch.animal}".downcase
    end

    def dob_year
      dob.year if dob
    end

    def dob_month
      dob.month if dob
    end

    def dob_day
      dob.day if dob
    end

    def dob_time
      dob
    end

    def year
      @year ||= Pillar.find_by_ordinal(year_id)
    end

    def month
      @month ||= Pillar.find_by_ordinal(month_id)
    end

    def day
      @day ||= Pillar.find_by_ordinal(day_id)
    end

    def hour
      @hour ||= Pillar.find_by_ordinal(hour_id)
    end

    def name
      hr = hour.branch.ordinal
      solar_date.strftime('%Y-%m-%d-' + (hr < 10 ? "0#{hr}" : hr).to_s)
    end
  end

  concerning :FriendlyId do
    def slug_candidates
      [
        [:person_name],
        [:person_name, :member_id]
      ]
    end
    included do
      def self.find_by_slug!(slug)
        friendly.find(slug)
      end
    end
  end

  def method_missing(method, *args)
    star_name = method.to_s.gsub(/=/, '').to_sym
    super unless star_name.in? Star::STAR_PINYIN
    ActiveSupport::Deprecation.warn("Called nonexistent class method #{method} on Chart.")
    if method.to_s =~ /=$/
      branch = args.first
      self["#{star_name}_id"] = branch.ordinal
    else
      Branch.find_by_ordinal self["#{star_name}_id"]
    end
  end
end
