class StarsController < ApplicationController
  load_and_authorize_resource :star, find_by: :pinyin

  def index
  end

  def show
  end
end
