require 'awesome_print'

class ApplicationController < ActionController::Base
  LodgeSettings = Settings.lodge
  PER_SIZE = LodgeSettings.per_size
  RIGHT_LIST_SIZE = LodgeSettings.right_list_size

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  #before_action :read_tags, except: [:sign_in, :sign_up]
  before_action :read_recent_feed, except: [:sign_in, :sign_up]
  before_action :read_recent_articles, except: [:sign_in, :sign_up]
  before_action :read_stocks, except: [:sign_in, :sign_up]
  before_action :read_notifications, except: [:sign_in, :sign_up]
  before_action :read_user_articles, except: [:sign_in, :sign_up]
  before_action :read_popular_articles, except: [:sign_in, :sign_up]
  before_action :read_recent_tags, except: [:sign_in, :sign_up]
  before_action :read_users, except: [:sign_in, :sign_up]
  before_action :load_pre_url
  before_action :set_pre_url, except: [:new, :edit, :show, :create, :update, :destroy, :sign_up, :preview, :list]

  helper_method :current_or_guest_user


  #
  # authentication
  #

  def authenticate_user!
    unless current_or_guest_user then
      super
    end
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    return current_user if ENV['ANONYMOUS_MODE'] != 'on'
    if current_user
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    unless @cached_guest_user then
      u = User.find_by_email(Settings.lodge[:guest_email])
      u ||= create_guest_user
      @cached_guest_user = u
    end
    @cached_guest_user
  end

  private

  def create_guest_user
    u = User.create(:name => Settings.lodge[:guest_name], :email => Settings.lodge[:guest_email], :password => SecureRandom.urlsafe_base64, confirmed_at: Date.today, read_only: 't')
    u.save!(:validate => false)
    u
  end


  #
  # other
  #

  public

  def read_recent_feed
    return if not current_or_guest_user
    @recent_feed = Article.tagged_with(current_or_guest_user.following_tag_list, any: true)
      .order(:created_at => :desc).limit(RIGHT_LIST_SIZE)
  end

  def read_recent_articles
    @recent_articles = []
    return if not current_or_guest_user
    @recent_articles = Article.order("created_at DESC").limit(RIGHT_LIST_SIZE)
  end

  def read_stocks
    @stocked_articles = []
    return if not current_or_guest_user
    @stocked_articles = current_or_guest_user.stocked_articles.order("stocks.updated_at desc").limit(RIGHT_LIST_SIZE)
  end

  def read_user_articles
    return if not current_or_guest_user
    @user_articles = current_or_guest_user.articles.order("articles.updated_at desc").limit(RIGHT_LIST_SIZE)
  end

  def read_popular_articles
    return if not current_or_guest_user
    popular_stocks = Stock.joins(:article)
      .where("articles.created_at > ?", 2.week.ago)
      .group("stocks.article_id", "articles.updated_at")
      .order("count_article_id desc", "articles.updated_at desc")
      .limit(RIGHT_LIST_SIZE)
      .count(:article_id)
    popular_articles = Article.includes(:stocks).where(id: popular_stocks.keys.map{|x| x.first})
    @popular_articles = []
    popular_stocks.each do |keys, count|
      @popular_articles << popular_articles.select {|a| a.id == keys.first}.first
    end
  end

  def read_recent_tags
    @recent_tags = []
    return if not current_or_guest_user
    @recent_tags = Article.new.tag_counts_on(:tags).order("id DESC").limit(RIGHT_LIST_SIZE)
  end

  def read_users
    return if not current_or_guest_user
    @users = User.all.limit(RIGHT_LIST_SIZE)
  end

  def read_notifications
    @notifications = []
    return if not current_or_guest_user
    @notifications = Notification
      .joins(:notification_targets)
      .includes({:article => :user}, :user)
      .where("notification_targets.user_id = ?", current_or_guest_user.id)
      .order(:updated_at => :desc)
  end

  def load_pre_url
    @pre_accessable_url = session[:pre_accessable_url]
  end

  def set_pre_url
    session[:pre_accessable_url] = request.url
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
