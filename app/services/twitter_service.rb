# frozen_string_literal: true

class TwitterService
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ''
      config.consumer_secret     = ''
      config.access_token        = ''
      config.access_token_secret = ''
    end
  end

  def tweet(message)
    @client.update(message)
  end
end
