# frozen_string_literal: true

class DiscordBotJob
  include Sidekiq::Worker
  queue_as :default

  def perform
    DiscordServices::DiscordBot.instance.start
  end
end
