# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token
  require 'google/apis/drive_v3'

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

  def receive
    channel_id = request.headers['X-Goog-Channel-Id']

    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.authorization = authorize

    folder = Folder.find_by(channel_id:)
    return if folder.nil?

    response = drive_service.list_files(q: "'#{folder.drive_folder_id}' in parents",
                                        spaces: 'drive',
                                        fields: 'nextPageToken, files(id, name, mimeType)')

    # Convertir les fichiers de réponse en un hash avec des clés ID pour une recherche facile
    response_files_hash = response.files.index_by(&:id)

    # Boucle à travers les fichiers existants de folder.drive_files
    folder.documents.each do |file|
      # Si un fichier existant n'est pas dans response.files, alors il a été supprimé
      unless response_files_hash[file.drive_file_id]
        puts "Fichier supprimé: #{file.name}"
        file.destroy # ou marquez-le comme supprimé, selon vos besoins
      end
      # Retirer le fichier de response_files_hash pour ne pas le traiter à nouveau
      response_files_hash.delete(file.drive_file_id)
    end

    # Maintenant, response_files_hash ne contient que les nouveaux fichiers
    response_files_hash.each_value do |new_file|
      folder.documents.create(drive_file_id: new_file.id, name: new_file.name)  # ajoutez d'autres attributs si nécessaire
      DiscordServices::SendMessage.new(folder.webhook_url,
                                       "Nouveau #{type(new_file.mime_type)} #{new_file.name} ajouté au drive:", new_file).call
    end

    render json: {}, status: :ok
  end

  def type(type)
    case type
    when 'application/vnd.google-apps.folder'
      'dossier'
    else
      'fichier'
    end
  end
end
