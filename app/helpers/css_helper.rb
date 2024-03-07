module CssHelper
  def header_classes(*additional_classes, remove: [])
    @header_classes ||= %w[
      bg-joy-theme-bg-1
      text-joy-theme-text
      h-16
      print:hidden
      sticky
      top-0
      z-10
    ]

    @header_classes += Array(additional_classes)
    @header_classes -= Array(remove)
  end

  def body_classes(*additional_classes)
    @body_classes ||= %w[
      antialiased
      text-gray-text
      bg-joy-theme-bg-1
    ]

    @body_classes += Array(additional_classes)
  end

  def footer_classes(*additional_classes)
    @footer_classes ||= %w[
      antialiased
      bg-joy-theme-bg-2
      mt-32
      print:hidden
    ]

    @footer_classes += Array(additional_classes)
  end
end
