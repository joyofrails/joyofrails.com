class SampleJob < ApplicationJob
  def perform
    Rails.logger.info "SampleJob is working!"
  end
end
