class Share::SnippetsController < ApplicationController
  using Refinements::Emojoy

  before_action :feature_enabled!, except: %i[index show]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  # GET /snippets
  def index
    @snippets = Snippet.all.with_attached_screenshot.includes(:author).order(created_at: :desc)
  end

  # GET /snippets/1
  def show
    @snippet = Snippet.find(params[:id])

    fresh_when(@snippet, public: true) unless user_signed_in?
  end

  # GET /snippets/new
  def new
    default_params = {
      filename: "app/models/user.rb",
      source: "class User < ApplicationRecord\n\s\shas_many :posts\nend",
      language: "ruby"
    }
    @snippet = current_user.snippets.new(snippet_params.presence || default_params)
  end

  # GET /snippets/1/edit
  def edit
    @snippet = current_user.snippets.find(params[:id])
    @snippet.assign_attributes(snippet_params)
  end

  # POST /snippets
  def create
    @snippet = current_user.snippets.new(snippet_params)

    if @snippet.save
      redirect_to share_snippet_redirect_url(@snippet), notice: "Your snippet has been saved".emojoy, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /snippets/1
  def update
    @snippet = current_user.snippets.find(params[:id])
    if @snippet.update(snippet_params)
      @snippet.attach_screenshot_from_base64(params[:screenshot]) if params[:screenshot]

      redirect_to share_snippet_redirect_url(@snippet), notice: "Your snippet has been saved".emojoy, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /snippets/1
  def destroy
    @snippet = current_user.snippets.find(params[:id])
    @snippet.destroy!
    redirect_to share_snippets_url, notice: "Your snippet has been deleted permanently".emojoy, status: :see_other
  end

  private

  def share_snippet_redirect_url(snippet)
    case params[:commit]
    when "Share"
      new_share_snippet_screenshot_url(snippet)
    else
      edit_share_snippet_url(snippet)
    end
  end

  # Only allow a list of trusted parameters through.
  def snippet_params
    params.fetch(:snippet, {}).permit(:filename, :source, :language)
  end

  def feature_enabled!
    return if user_signed_in? &&
      Flipper.enabled?(:snippets, current_user)

    raise ActionController::RoutingError.new("Not Found")
  end
end
