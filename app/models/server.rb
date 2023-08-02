# frozen_string_literal: true

class Server < ApplicationRecord
  belongs_to :user
  has_one :root_folder, -> { where(root_folder: true) }, class_name: 'Folder', dependent: :destroy
end
