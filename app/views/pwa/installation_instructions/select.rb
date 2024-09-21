class Pwa::InstallationInstructions::Select < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith

  def initialize(selected_nickname: nil)
    @selected_nickname = selected_nickname
  end

  def view_template
    form_with(url: pwa_installation_instructions_path, method: :get) do |f|
      fieldset do
        f.select(
          :user_agent_nickname,
          select_options,
          {
            selected: @selected_nickname
          },
          onchange: "this.form.requestSubmit()",
          class: ""
        )
        noscript { f.submit "Go", class: "button primary" }
      end
    end
  end

  private

  def select_options
    Pwa::NamedInstallationInstructions.user_agent_nicknames.map do |partial_name|
      [titleize(partial_name), partial_name]
    end
  end

  def titleize(partial_name)
    partial_name
      .tr("_", " ")
      .gsub(/(?:\A|\s)\w/) { |match| match.upcase }
      .gsub(/macos/i, "macOS")
      .gsub(/ios/i, "iOS")
      .gsub(/ipad/i, "iPad")
  end
end
