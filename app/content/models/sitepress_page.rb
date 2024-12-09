class SitepressPage < Sitepress::Model
  collection glob: "**/*.html*"
  data :title
end
