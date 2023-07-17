# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Server.destroy_all
User.destroy_all

tao = User.create(email: 'florent.guilbaud@gmail.com', password: '123456')
Server.create(name: "TBA", user: tao, token: 'MTEyODMwMDkxNTA5OTY5NzIyMw.GHyguY.CxVPHGSU71yUvvuFrsSkpVhsUb4vFJgw52Zwl0', root_folder_id: '1ye7NFZ-dGBwFMLRtJm-oJR05mwZYDx1x')
