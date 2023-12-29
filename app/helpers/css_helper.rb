module CssHelper
  def header_classes(*additional_classes, remove: [])
    @header_classes ||= %w[
      bg-background
      text-theme-text
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
      bg-background
    ]

    @body_classes += Array(additional_classes)
  end

  def footer_classes(*additional_classes)
    @footer_classes ||= %w[
      antialiased
      bg-theme-bg
      mt-32
      print:hidden
    ]

    @footer_classes += Array(additional_classes)
  end
end
