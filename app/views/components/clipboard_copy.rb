class ClipboardCopy < Phlex::HTML
  include InlineSvg::ActionView::Helpers

  attr_accessor :text

  def initialize(text:)
    @text = text
  end

  def view_template
    div(
      data_controller: "clipboard-copy",
      class: "clipboard-copy-container"
    ) do
      whitespace
      button(
        aria_label: "Copy to clipboard",
        type: "button",
        class:
          "button--clipboard-copy text-gray-500 dark:text-gray-400 group rounded-md text-sm md:p-2 relative",
        data_action: "clipboard-copy#copy",
        data_clipboard_copy_target: "source",
        data_value: ERB::Util.html_escape(text)
      ) do
        whitespace
        span(
          class:
            "absolute hidden text-xs md:text-base top-0 md:top-[3px] left-[-68px] md:left-[-72px] group-focus:inline py-1 px-2 text-white font-semibold bg-black rounded-m"
        ) { "Copied!" }
        whitespace
        raw inline_svg_tag "copy-text.svg",
          class:
            "copy-text inline-block cursor-pointer fill-current group-focus:hidden w-[16px] md:w-[20px]"
        whitespace
        raw inline_svg_tag "check-mark.svg",
          class:
            "check-mark hidden fill-green-600 group-focus:inline-block w-[16px] md:w-[20px]"
        whitespace
      end
    end
  end
end
