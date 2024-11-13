module PhlexConcerns::FlexBlock
  def flex_block(options = {}, &)
    div(
      **mix(options, class: "flex items-start flex-col space-col-4 grid-cols-12 md:items-center md:flex-row md:space-row-4"),
      &
    )
  end
end
