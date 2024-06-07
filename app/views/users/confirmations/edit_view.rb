class Users::Confirmations::EditView < Phlex::HTML
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes
  include InlineSvg::ActionView::Helpers

  def initialize(user:, confirmation_token:)
    @user = user
    @confirmation_token = confirmation_token
  end

  def view_template
    render Layouts::FrontDoor.new(title: "One-click confirm") do
      form_with model: @user,
        url: users_confirmations_path(@confirmation_token),
        class: "space-y-6" do |form|
        div(class: "pt-6") do
          plain form.button "Confirm email: #{@user.email}",
            type: :submit,
            class:
              "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        end
      end
    end
  end
end
