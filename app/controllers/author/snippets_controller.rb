module Author
  class SnippetsController < ApplicationController
    using Refinements::Emojoy

    before_action :feature_enabled!
    before_action :authenticate_user!

    def index
      @snippets = Current.user.snippets.includes(:author).order(created_at: :desc)
    end

    def show
      @snippet = Current.user.snippets.find(params[:id])
    end

    def new
      default_params = {
        filename: "app/models/user.rb",
        source: "class User < ApplicationRecord\n\s\shas_many :posts\nend",
        language: "ruby"
      }
      @snippet = Current.user.snippets.new(snippet_params.presence || default_params)
    end

    def edit
      @snippet = Current.user.snippets.find(params[:id])
      @snippet.assign_attributes(snippet_params)
    end

    def create
      @snippet = Current.user.snippets.new(snippet_params)

      if @snippet.save
        redirect_to author_snippet_redirect_url(@snippet), notice: "Your snippet has been saved".emojoy, status: :see_other
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @snippet = Current.user.snippets.find(params[:id])
      if @snippet.update(snippet_params)
        @snippet.attach_screenshot_from_base64(params[:screenshot]) if params[:screenshot]

        redirect_to author_snippet_redirect_url(@snippet), notice: "Your snippet has been saved".emojoy, status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @snippet = Current.user.snippets.find(params[:id])
      @snippet.destroy!
      redirect_to author_snippets_url, notice: "Your snippet has been deleted permanently".emojoy, status: :see_other
    end

    private

    def author_snippet_redirect_url(snippet)
      case params[:commit]
      when /Close/
        author_snippet_url(snippet)
      else
        edit_author_snippet_url(snippet)
      end
    end

    def snippet_params
      params.fetch(:snippet, {}).permit(:filename, :source, :language, :description, :title)
    end

    def feature_enabled!
      return if user_signed_in? &&
        Flipper.enabled?(:snippets, current_user)

      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
