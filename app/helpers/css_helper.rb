module CssHelper
  def header_classes(*additional_classes)
    @header_classes ||= %w[
      text-accent-text
      h-16
      print:hidden
      sticky
      top-0
      z-10
    ]

    @header_classes += Array(additional_classes)
  end

  def body_classes(*additional_classes)
    @body_classes ||= %w[
      antialiased
      text-gray-text
    ]

    @body_classes += Array(additional_classes)
  end

  def footer_classes(*additional_classes)
    @footer_classes ||= %w[
      antialiased
      mt-96
      print:hidden
    ]

    @footer_classes += Array(additional_classes)
  end
end
