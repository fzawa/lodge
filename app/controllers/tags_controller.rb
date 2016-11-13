class TagsController < ApplicationController
  before_action :set_tag, only: [:follow, :unfollow]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Article.tag_counts.page(params[:page]).per(PER_SIZE).order(id: :desc)
    @following_tags = current_or_guest_user.following_tag_list
  end

  def follow
    current_or_guest_user.follow(@tag)
  end

  def unfollow
    current_or_guest_user.unfollow(@tag)
    render :follow
  end

  def list
    tags = Article.tag_counts.where("name LIKE ?", "%#{params[:q]}%")

    respond_to do |format|
      format.html
      format.json { render :json => tags.select(:id, :name, :taggings_count) }
    end
  end

private

  def set_tag
    @tag = params[:tag]
  end


end
