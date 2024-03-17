module HeaderNavigationHelper
  def header_navigation_button_to(text, path, options = {})
    button_to text, path, options.merge(
      class: "
        flex justify-center items-center h-full px-2
        rounded mr-2
        hover:bg-joy-bg-hover
      "
    )
  end

  def header_navigation_link_to(text, path, options = {})
    link_to text, path, options.merge(
      class: "
        flex justify-center items-center px-2
        rounded mr-2
        hover:bg-joy-bg-hover
      "
    )
  end
end
