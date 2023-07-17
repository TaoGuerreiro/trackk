# frozen_string_literal: true

require 'googleauth'
require 'google/apis/drive_v3'
require 'discordrb'

module DiscordServices
  class Drive
    APPLICATION_NAME = 'taotips-393110'
    SCOPE = Google::Apis::DriveV3::AUTH_DRIVE

    def key
      {
        "type": 'service_account',
        "project_id": 'taotips-393110',
        "private_key_id": Rails.application.credentials.google_drive.private_key_id,
        "private_key": Rails.application.credentials.google_drive.private_key.gsub('\\n', "\n"),
        "client_email": Rails.application.credentials.google_drive.client_email,
        "client_id": Rails.application.credentials.google_drive.client_id,
        "auth_uri": 'https://accounts.google.com/o/oauth2/auth',
        "token_uri": 'https://oauth2.googleapis.com/token',
        "auth_provider_x509_cert_url": 'https://www.googleapis.com/oauth2/v1/certs',
        "client_x509_cert_url": Rails.application.credentials.google_drive.client_x509_cert_url,
        "universe_domain": 'googleapis.com'
      }
    end

    def authorize
      json_key_io = StringIO.new(JSON.generate(key))

      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io:,
        scope: SCOPE
      )
    end

    def initialize
      @service = Google::Apis::DriveV3::DriveService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize
    end

    def create_root_folder(name)
      file_metadata = {
        name:,
        mime_type: 'application/vnd.google-apps.folder'
      }
      file = @service.create_file(file_metadata, fields: 'id')

      file_metadata = {
        name: 'tracks',
        mime_type: 'application/vnd.google-apps.folder',
        parents: [file.id]
      }
      tracks_folder = @service.create_file(file_metadata, fields: 'id')

      # Crée une nouvelle permission pour le dossier
      permission = Google::Apis::DriveV3::Permission.new(
        type: 'user',
        role: 'writer',
        send_notification_email: false,
        transfer_ownership: true,
        email_address: 'florent.guilbaud@gmail.com'
      )

      # Applique la permission au dossier
      @service.create_permission(
        file.id,
        permission
      )

      {
        tracks: tracks_folder.id,
        root: file.id
      }
    end

    def create_folder(event, webhook_url)
      server = Server.find_by(token: event.server.id)

      file_metadata = {
        name: event.name,
        mime_type: 'application/vnd.google-apps.folder',
        parents: [server.tracks_folder_id]
      }
      track_folder = @service.create_file(file_metadata, fields: 'id')
      set_webhook(track_folder.id, webhook_url, server)

      file_metadata = {
        name: 'stems',
        mime_type: 'application/vnd.google-apps.folder',
        parents: [track_folder.id]
      }
      sub_folder = @service.create_file(file_metadata, fields: 'id')
      set_webhook(sub_folder.id, webhook_url, server)

      file_metadata = {
        name: 'tablatures',
        mime_type: 'application/vnd.google-apps.folder',
        parents: [track_folder.id]
      }
      sub_folder = @service.create_file(file_metadata, fields: 'id')
      set_webhook(sub_folder.id, webhook_url, server)

      track_folder
    end

    def set_webhook(file_id, webhook_url, server)
      # Vous devez configurer l'authentification avant cette étape
      channel_id = SecureRandom.uuid
      resource_id = SecureRandom.uuid # L'id de la ressource est généré par votre application, il est utilisé pour s'assurer que les notifications que vous recevez proviennent bien de Google.
      channel_type = 'web_hook'

      channel_address = 'https://www.taoguerreiro.com/google_drive/webhook' if Rails.env.production?
      channel_address = 'https://bicicouriers.eu.ngrok.io/google_drive/webhook' if Rails.env.development?

      channel = Google::Apis::DriveV3::Channel.new(address: channel_address, type: channel_type, id: channel_id,
                                                   resource_id:)
      @service.watch_file(file_id, channel)
      # ::DriveFolder.create(channel_id:, resource_id:, file_id:, webhook_url:)
      Folder.create(channel_id:, resource_id:, drive_folder_id: file_id, webhook_url:, server:)
    end

    def stop_channel(channel_id, resource_id)
      channel = Google::Apis::DriveV3::Channel.new(id: channel_id, resource_id:)
      begin
        @service.stop_channel(channel)
        ::DriveFolder.find_by(channel_id:).destroy
      rescue Google::Apis::Error => e
        puts "An error occurred: #{e.message}"
      end
    end
  end
end
