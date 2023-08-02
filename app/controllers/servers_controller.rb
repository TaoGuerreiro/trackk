# frozen_string_literal: true

class ServersController < ApplicationController
  def index
    @servers = Server.all
  end

  def show
    @server = Server.find(params[:id])
  end

  def new
    @server = Server.new
  end

  def edit; end

  def update; end

  def create
    @server = Server.new(server_params)
    @server.user = current_user
    ids = DiscordServices::Drive.new.create_root_folder(@server.name)

    @server.tracks_folder_id = ids[:tracks]
    @server.root_folder_id = ids[:root]
    root_folder = Folder.create(root_folder: true, server: @server, drive_folder_id: ids[:root])
    tracks_folder = Folder.create(server: @server, drive_folder_id: ids[:tracks], parent_folder_id: root_folder.id, name: "Tracks")
    root_folder.subfolders << tracks_folder
    root_folder.save
    if @server.save
      redirect_to servers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def server_params
    params.require(:server).permit(:name, :token)
  end
end
