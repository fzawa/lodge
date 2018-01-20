class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    # for json
    user_hash = @user.attributes
    user_hash.reject! {|k,v| [:encrypted_password, :email].include?(k.to_sym) }
    user_hash[:contribution] = @user.contribution
    user_hash[:articles] = @user.articles.order(updated_at: :desc).limit 5

    # for html
    @user_articles = Article.owned_by(@user, params[:page])

    respond_to do |format|
      format.json { render json: user_hash.to_json }
      format.html
    end
  end
end
