class LunarDate < ActiveRecord::Base
  include LunarDateLoader
  attr_accessor :date_time
  MONTH_STEM_LOOKUP= [[1,	2,	3,	4,	5,	6,	7,	8,	9,	10,	1,	2],
                      [3,	4,	5,	6,	7,	8,	9,	10,	1,	2,	3,	4],
                      [5,	6,	7,	8,	9,	10,	1,	2,	3,	4,	5,	6],
                      [7,	8,	9,	10,	1,	2,	3,	4,	5,	6,	7,	8],
                      [9,	10,	1,	2,	3,	4,	5,	6,	7,	8,	9,	10]].freeze

  HOUR_STEM_LOOKUP = [%i(jia yi bing ding wu ji geng xin ren kui jia yi),
                      %i(bing ding wu ji geng xin ren kui jia yi bing ding),
                      %i(wu ji geng xin ren kui jia yi bing ding wu ji),
                      %i(geng xin ren kui jia yi bing ding wu ji geng xin),
                      %i(ren kui jia yi bing ding wu ji geng xin ren kui)].freeze

  LUNAR_MONTH_TRANSLATION = [0, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].freeze

  def as_json(unused=nil)
    {
      year: year_pillar.as_json,
      month: month_pillar.as_json,
      day: day_pillar.as_json,
      hour: hour_pillar.as_json,
      day_of_month: day_of_month,
      lunar_year: lunar_year,
      leap_month: leap_month,
      solar_date: gregorian_date.strftime("%Y-%m-%d %H:%M")
    }
  end

  def stored_attributes
    {
      year_id: year_pillar.ordinal,
      month_id: month_pillar.ordinal,
      day_id: day_pillar.ordinal,
      hour_id: hour_pillar.ordinal,
      lunar_year: lunar_year,
      lunar_month: lunar_month,
      leap: leap_month,
      day_of_month: day_of_month
    }
  end

  def year_pillar
    @year_pillar ||= Pillar.find_by_ordinal(year_in_epoch)
  end

  def month_pillar
    stem_id = MONTH_STEM_LOOKUP[year_pillar.id % 5][month_number - 1]
    branch_id = [0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2][month_number]
    Pillar.find_by_stem_and_branch(stem_id, branch_id)
  end

  def day_pillar
    # @day_pillar ||= lambda {
      days = days_since(gregorian_date)
      Pillar.find_by_ordinal(days % 60 + 1)
    # }.call
  end

  def hour_pillar
    # @hour_pillar ||= lambda {
      hour_number = ((date_time.hour + 1) / 2) % 12 + 1

      stem = Stem.find_by_pinyin HOUR_STEM_LOOKUP[(day_pillar.stem.ordinal-1)%5][hour_number-1]
      # byebug
      Pillar.find_by_stem_and_branch stem.id, hour_number
    # }.call
  end

  def lunar_year
    (epoch * 60) + 1 + year_in_epoch
  end

  def lunar_month
    LUNAR_MONTH_TRANSLATION[month_pillar.branch.ordinal]
  end

  INITIAL_DATE = Date.parse("1924-04-15").freeze
  def days_since(d)
    if d.kind_of?(String)
      d = Date.parse(d)
    end
    (d - INITIAL_DATE).to_i
  end

  def self.rebuild
    years = {}
    this_month = ''
    File.open('compressed.dat', 'w') do |f|
      File.readlines('lunar_dates.dat').each do |line|
        data = line.split
        key = data.shift
        data = data.map(&:to_i)

        year = key[0..3]
        month = key[4..5].to_i
        day   = key[6..7].to_i
        if day == 1 && !this_month.blank?
          f.write(this_month + "\n")
          this_month = ''
        end
        if month == day && day == 1
          f.write(year + "\n")
        end
        this_month += ' ' unless day == 1
        this_month += LunarDateLoader.serialize_line(data)
        print '.'
      end
    end
    nil
  end

end
