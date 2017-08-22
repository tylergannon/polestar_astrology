class PalacesController < ApplicationController
  load_resource :star, find_by: :pinyin, parent: true
  load_resource :palace, find_by: :friendly, parent: false

  def show
    puts @star.inspect
    puts @palace.inspect
    @relationships = StarRelationship.
                      joins(:stars).
                      where(palace_id: @palace.id, stars: {id: @star.id})
  end

end
