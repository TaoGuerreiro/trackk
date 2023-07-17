# frozen_string_literal: true

require_relative '../../app/services/discord_services/discord_bot'
require_relative '../../app/jobs/discord_bot_job'

Rails.application.config.after_initialize do
  DiscordBotJob.perform_async
end
