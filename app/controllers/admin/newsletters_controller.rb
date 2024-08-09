class Admin::NewslettersController < ApplicationController
  before_action :set_newsletter, only: %i[show edit update destroy deliver]

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
    redirect_to admin_newsletters_path, notice: "Newsletter was successfully destroyed.", status: :see_other
  end

  # PATCH /admin/newsletters/1/deliver
  def deliver
    @newsletter = Newsletter.find(params[:id])
    recipients = deliver_live? ? User.subscribers : User.test_recipients
    label = deliver_live? ? "LIVE" : "TEST"

    if recipients.empty?
      return redirect_to [:admin, @newsletter], alert: "No recipients found."
    end

    NewsletterNotifier.deliver_to(recipients, newsletter: @newsletter)

    redirect_to [:admin, @newsletter], notice: "[#{label}] Newsletter was successfully delivered."
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

  def deliver_live? = params[:live] == "true"
end
