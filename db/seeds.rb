# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
groups = ["Двигатель", "Колёса", "Кузов", "Стекла", "Топливная система", "Тормозная система", "Электрика", "Тест"]
groups.each { |n| CatGroup.create(name: n) }

cat_names = ["Тестовая 1", "Тестовая 2", "Тестовая 3", "Тестовая 4", "Тестовая 5"]
cat_names.each do |name|
  cat = Category.new(name: name)
  cat.cat_groups << CatGroup.last
  cat.cat_groups << CatGroup.first
  cat.save
end
