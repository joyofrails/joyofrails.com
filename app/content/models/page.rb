class Page < Sitepress::Model
  collection glob: "**/*.html*"
  data :title
end
