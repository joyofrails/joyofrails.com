class Pwa::InstallationInstructionsController < ApplicationController
  def show
    @installation_instructions = Pwa::InstallationInstructions.new(request.user_agent)
  end
end
