module ChartsHelper
  def palace_animal_display(chart_palace)
    [chart_palace.location.char, chart_palace.location.pinyin, chart_palace.location.animal].join(' ')
  end

  def borrowed_stars(palace)
    @chart.palaces.find{ |other_palace|
      other_palace.location == palace.location.diametric
    }.major_stars.sort_by &:rank
  end

  def major_stars(palace)
    palace.major_stars.sort_by &:rank
  end

  def minor_stars(palace)
    palace.minor_stars.sort_by &:rank
  end

  ORDINATORS = ['th', 'st', 'nd', 'rd']

  def ordinate(number)
    content_tag :span do
      concat number.to_s
      concat content_tag :sup, (ORDINATORS[number] || 'th')
    end
  end
end
