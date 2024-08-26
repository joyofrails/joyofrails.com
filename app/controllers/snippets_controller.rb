class SnippetsController < ApplicationController
  before_action :feature_enabled!

  # GET /snippets
  def index
    @snippets = Snippet.all
  end

  # GET /snippets/1
  def show
    @snippet = Snippet.find(params[:id])
  end

  # GET /snippets/new
  def new
    default_params = {
      filename: "app/models/user.rb",
      source: "class User < ApplicationRecord\n\s\shas_many :posts\nend",
      language: "ruby"
    }
    @snippet = Snippet.new(snippet_params.presence || default_params)
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
    @snippet.assign_attributes(snippet_params)
  end

  # POST /snippets
  def create
    @snippet = Snippet.new(snippet_params)

    if @snippet.save
      redirect_to @snippet, notice: "Snippet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /snippets/1
  def update
    @snippet = Snippet.find(params[:id])
    if @snippet.update(snippet_params)
      @snippet.attach_screenshot_from_base64(params[:screenshot]) if params[:screenshot]
      redirect_to @snippet, notice: "Snippet was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /snippets/1
  def destroy
    @snippet = Snippet.find(params[:id])
    @snippet.destroy!
    redirect_to snippets_url, notice: "Snippet was successfully destroyed.", status: :see_other
  end

  private

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
