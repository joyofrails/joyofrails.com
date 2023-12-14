module HeaderHelper
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
end
