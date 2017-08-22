module StarRelationshipsHelper
  def star_relationship_description(star_relationship, star=nil)
    required = sort_stars(star_relationship.required_stars, star)
    optional = sort_stars(star_relationship.optional_stars, star)

    str = listerize(required) + " in the #{star_relationship.palace.name} Palace"
    if optional.any?
      str += (" with #{'either ' if optional.size > 1}" + listerize(optional, final: 'or').html_safe).html_safe
    end
    str.html_safe
  end

  def sort_stars(collection, primary=nil)
    collection.sort do |left, right|
      if left == primary
        -1
      elsif right == primary
        1
      else
        left <=> right
      end
    end
  end

  def listerize(collection, final: 'and')
    names = collection.map do |star|
      link_to(star.english, star).html_safe
    end
    if names.length == 1
      names.first
    elsif names.length == 2
      names.join(" #{final} ")
    else
      str = names[0..-2].join(', ')
      [str, names[-1]].join(" #{final} ")
    end
  end
end
