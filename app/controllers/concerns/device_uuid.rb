module DeviceUuid
  extend ActiveSupport::Concern

  included do
    helper_method :ensure_device_uuid
  end

  protected

  def ensure_device_uuid
    cookies.signed[:device_uuid] ||= SecureRandom.uuid_v7
  end
end
