class Examples::HelloController < ApplicationController
  def show
    render layout: "examples/minimal"
  end
end
