class RelationshipsController < ApplicationController
  load_resource :star, find_by: :pinyin, parent: true
  load_resource :palace, find_by: :friendly, parent: true

  def new
    @star_relationship = StarRelationship.new palace: @palace
    @star_relationship.star_relationship_stars.build(star: @star, required: true)
    3.times do
      @star_relationship.star_relationship_stars.build(required: true)
    end
  end

  def create
    @star_relationship = StarRelationship.find_or_create @palace,
                                      *get_star_relationship_stars_from_params

    if star_relationship_params.key? :comments
      unless star_relationship_params[:comments][:comments].blank?
        Comment.create({
          member_id: current_member.id,
          commentable: @star_relationship,
        }.merge(star_relationship_params[:comments]))
      end
    end

    redirect_to [@star, @palace]
  end

  private

  def get_star_relationship_stars_from_params
    star_relationship_params[:star_relationship_stars].select do |params|
      params[:star_id].to_i > 0
    end.map do |params|
      StarRelationshipStar.new  star_id:  params[:star_id],
                                required: (params[:required] == 'on')
    end
  end

  def star_relationship_params
    params.require(:star_relationship).permit(
      star_relationship_stars: [:star_id, :required],
      comments: [:comments, :citation])
  end
end
