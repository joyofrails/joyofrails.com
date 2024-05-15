require "solid_cable"

SolidCable.connects_to = {database: {writing: :cable, reading: :cable}}
