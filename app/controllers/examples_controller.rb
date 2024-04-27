class ExamplesController < ApplicationController
  def index
  end

  def show
    paths = Dir.glob(Rails.root.join("app", "views", "examples", "ruby", "*.rb"))
    path = paths.find { |path| File.basename(path, ".rb") == params[:id] } or raise ActiveRecord::RecordNotFound, "Could not find example: #{params[:id]}"
    example = Examples::AppFile.find(path)

    render locals: {example: example}
  end
end
