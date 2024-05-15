require "solid_cable"

Rails.application.config.solid_cable.each do |name, value|
  SolidCable.public_send(:"#{name}=", value)
end
