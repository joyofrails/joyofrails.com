# A Slash Page is a page that is rendered at the root of the site
# like /about, /contact, etc.
#
# https://slashpages.net/
#
class SitepressSlashPage < Sitepress::Model
  collection glob: "{about,contact,settings,deploy}/**/*.html*"
  data :title
end
