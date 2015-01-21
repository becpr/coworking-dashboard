require 'newsblurry'
require 'dotenv'

Dotenv.load

@agent = Newsblurry::Agent.new(ENV['NEWSBLUR_USERNAME'], ENV['NEWSBLUR_PASSWORD'])

date = Date.today
filename = "blogs_#{date}.csv"


CSV.open("#{filename}", 'wb') do |csv|
    @agent.unread_stories.each do |articles|
        csv << [articles.feed_title, articles.title, articles.published_at, articles.link]
        @agent.mark_as_read(articles.hash)
        puts 'done'
    end
end