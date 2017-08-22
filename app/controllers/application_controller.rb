class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_member!, unless: :pages?

  def star_relationship_url(star_relationship)
    star_palace_path(star_relationship.stars.first, star_relationship.palace)
  end

  def pages?
    self.kind_of? PagesController
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_member)
  end
end
