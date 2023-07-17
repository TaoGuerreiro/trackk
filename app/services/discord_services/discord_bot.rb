# frozen_string_literal: true

require 'singleton'
module DiscordServices
  class DiscordBot
    include Singleton

    def initialize
      @bot = Discordrb::Bot.new token: Rails.application.credentials.discord_token

      @bot.channel_create do |event|
        # Créer un dossier Google Drive et enregistrer l'ID
        webhook = event.channel.create_webhook(event.name)
        webhook_url = "https://discord.com/api/webhooks/#{webhook.id}/#{webhook.token}"

        DiscordServices::Drive.new.create_folder(event, webhook_url)
      end

      @bot.run
    end

    def start
      return if @running

      Thread.new { @bot.run }
      @running = true
    end

    def stop
      return unless @running

      @bot.stop
      @running = false
    end
  end
end
