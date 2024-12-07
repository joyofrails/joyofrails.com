class Guest
  def id = "guest_#{SecureRandom.hex(6)}"

  def persisted? = false

  def registered? = false

  def can_edit?(*) = false

  def flipper_id = self.class.name
end
