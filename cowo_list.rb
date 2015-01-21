require 'twitter'
require 'csv'
require 'dotenv'

Dotenv.load

@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

puts "Who is the list owner? (twitter handle)"
twitter_handle = gets.chomp
puts "What is the list called? (replace spaces with `-`)"
twitter_list = gets.chomp
puts "Thanks :) I'll look up https://twitter.com/#{twitter_handle}/lists/#{twitter_list}"

date = Date.today
filename = "#{twitter_list}_#{date}.csv"

CSV.open("#{filename}", 'wb') do |csv|
    @client.list_members(twitter_handle, twitter_list).each do |list|
        member = @client.user("#{list.screen_name}")
        csv << [member.screen_name, member.name, member.followers_count, member.friends_count, member.statuses_count, member.created_at]
    end
end
