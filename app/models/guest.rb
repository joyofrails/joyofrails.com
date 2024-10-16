class Guest
  def persisted? = false

  def flipper_id = self.class.name

  def can_edit?(*) = false
end
