class Guest
  def persisted? = false

  def registered? = false

  def can_edit?(*) = false

  def flipper_id = self.class.name
end
