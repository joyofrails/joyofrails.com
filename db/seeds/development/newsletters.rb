require "factory_bot_rails"

start_count_newsletters = 5
newsletter_fill_count = start_count_newsletters - Newsletter.count

FactoryBot.create_list(:newsletter, newsletter_fill_count) if newsletter_fill_count > 0
