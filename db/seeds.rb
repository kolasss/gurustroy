# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Unit.create name: 'кг.'
Unit.create name: 'шт.'
p 'Стандартные еденицы измерения'

Category.create name: 'Строительные материалы'
Category.create name: 'Отделочные материалы'
cat = Category.create name: 'Инструменты'
p 'Стандартные категории'

cat.tags.create name: 'бензопила'
cat.tags.create name: 'отвертка'
cat.tags.create name: 'лопата'
p 'Тэги для категории Инструменты'
