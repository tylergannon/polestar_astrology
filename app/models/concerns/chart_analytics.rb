module ChartAnalytics
  def most_empty_houses
    greatest_num = 1
    the_ones_that_did_it = []

    all.each do |chart|
      houses = {}; (1..12).each{|t| houses[t]=0}

      Star.all.each do |star|
        loc = chart.send "#{star.symbol_name}_id"
        houses[loc] += 1
      end
      empty = 0
      houses.each do |loc, num|
        empty += 1 if num == 0
      end

      if empty > greatest_num
        greatest_num = empty
        the_ones_that_did_it = [chart.id]
      elsif empty == greatest_num
        the_ones_that_did_it << chart.id
      end
    end

    logger.info "Greatest num: #{greatest_num}"
    logger.info "Who did it? #{the_ones_that_did_it}"
    return nil
  end

end
