class Admin::NewslettersController < ApplicationController
  before_action :set_newsletter, only: %i[show edit update destroy]

  # GET /admin/newsletters
  def index
    @newsletters = Newsletter.all
  end

  # GET /admin/newsletters/1
  def show
  end

  # GET /admin/newsletters/new
  def new
    @newsletter = Newsletter.new(newsletter_params)
  end

  # GET /admin/newsletters/1/edit
  def edit
  end

  # POST /admin/newsletters
  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save
      redirect_to [:admin, @newsletter], notice: "Newsletter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/newsletters/1
  def update
    if @newsletter.update(newsletter_params)
      redirect_to [:admin, @newsletter], notice: "Newsletter was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/newsletters/1
  def destroy
    @newsletter.destroy!
    redirect_to admin_newsletter_url, notice: "Newsletter was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def newsletter_params
    params.fetch(:newsletter, {}).permit(:title, :content)
  end
end
