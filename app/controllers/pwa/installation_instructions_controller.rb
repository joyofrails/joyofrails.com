class Pwa::InstallationInstructionsController < ApplicationController
  def show
    @installation_instructions = if params[:user_agent_nickname]
      Pwa::NamedInstallationInstructions.find(params[:user_agent_nickname])
    else
      Honeybadger.event("installation_instructions_controller.show", user_agent: request.user_agent)
      Pwa::UserAgentInstallationInstructions.new(request.user_agent)
    end
  end
end
