module PollHelper
  def render_lazy_page_poll(title)
    @data ||= YAML.load_file(Rails.root.join("app", "models", "polls", "lazy.yml"))

    question_data = @data.dig("polls", title)
    return "foogats" unless question_data
    render Share::Polls::LazyPagePoll.new(@current_page, title, question_data)
  end
end
