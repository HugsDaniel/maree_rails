# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Favorite.destroy_all
Port.destroy_all
User.destroy_all

hugs = User.create!(
  email: "hugo@example.com",
  password: "password",
  draught: 0.81,
  security_margin: 0.3
)

landrellec = Port.create!(name: "Pleumeur-Bodou", height: 2.5)
saint_malo = Port.create!(name: "SAINT-MALO", height: 2.5)

Favorite.create!(user: hugs, port: landrellec)
Favorite.create!(user: hugs, port: saint_malo)
