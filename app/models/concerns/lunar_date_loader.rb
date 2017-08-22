module LunarDateLoader
  extend ActiveSupport::Concern
  module ClassMethods
    def from_solar_date(d)
      date = d.to_date
      datestr = date.strftime('%Y%m%d')
      key = date_key(date.year, date.month)
      load_into_cache unless data = Rails.cache.read(key)
      data ||= Rails.cache.read(key)
      ld = LunarDate.new(gregorian_date: date, date_time: d)
      # byebug
      ld.attributes = deserialize_line data.split(' ')[date.day-1]
      return ld
    end

    private
    def load_into_cache
      puts "*"
      puts "* Loading Lunar Data"
      puts "*"
      year = 1900
      month = 1
      day = 1
      # File.readlines('compressed.dat').each do |line|
      Zip::File.open('compressed.dat.zip') do |zip_file|
        zip_file.glob('compressed.dat').first.get_input_stream.readlines.each do |line|
          line = line.strip
          if line.length == 4
            year = line.to_i
            month = 0
          else
            month += 1
            Rails.cache.write date_key(year, month), line
          end
        end
      end
      nil
    end

    def date_key(year, month)
      sprintf('%04d%02d', year, month)
    end

    def serialize_line(arr)
      sprintf('%02d%02d%02d%02d%01d', *arr)
    end

    def deserialize_line(line)
      {
        epoch: line[0..1].to_i,
        year_in_epoch: line[2..3].to_i,
        month_number: line[4..5].to_i,
        day_of_month: line[6..7].to_i,
        leap_month: (line[-1] == '1')
      }
    end
  end
end
