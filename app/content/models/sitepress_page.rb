class SitepressPage < Sitepress::Model
  data :title

  def self.all = glob("**/*.html*")
end
