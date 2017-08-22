class CommentsController < ApplicationController
  load_resource :star, find_by: :pinyin
  load_and_authorize_resource :comment, through: [:star], shallow: :true
  before_action :get_return_path, :set_parent_resource

  def index

  end

  # GET /comments/1
  # GET /comments/1.json
  def show

  end

  # GET /comments/new
  def new
  end

  # GET /comments/1/edit
  def edit
    session[:return_path] == request.referer unless request.referer == edit_comment_path(@comment)
  end

  # POST /comments
  # POST /comments.json
  def create
    # @comment = @parent_resource.comments.build comment_params
    @comment.member = current_member

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @parent_resource, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        # byebug
        format.html {
          unless redirect = session.delete(:return_path)
            redirect = @comment.commentable
          end


          redirect_to redirect, notice: 'Comment was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_parent_resource
      @parent_resource = @star
    end

    def get_return_path
      @return_path = request.env['referer']
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comments, :citation)
    end
end
