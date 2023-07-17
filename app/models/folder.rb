# frozen_string_literal: true

class Folder < ApplicationRecord
  belongs_to :server, optional: true
  has_many :documents
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_folder_id'
  belongs_to :parent_folder, class_name: 'Folder', optional: true
end
