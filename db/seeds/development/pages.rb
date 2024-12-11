SitepressPage.all.each do |sitepress_resource|
  Page.find_or_create_by!(request_path: sitepress_resource.request_path)
end
