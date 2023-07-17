# frozen_string_literal: true

require 'discordrb/webhooks'

module DiscordServices
  class SendMessage
    def initialize(webhook_url, content, file)
      @webhook_url = webhook_url
      @content = content
      @file = file
    end

    def call
      client = Discordrb::Webhooks::Client.new(url: @webhook_url)
      client.execute do |builder|
        builder.content = @content
        builder.add_embed do |embed|
          embed.title = @file.name
          embed.url = google_drive_file_url(@file.id)
          # Ajoutez d'autres informations à l'embed si nécessaire...
        end
      end
    end

    private

    def google_drive_file_url(file_id)
      "https://drive.google.com/file/d/#{file_id}/view?usp=drive_link"
    end
  end
end
