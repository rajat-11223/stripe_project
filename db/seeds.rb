# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#------------create Master Role------------#
puts "-------Started Adding Roles to table----"
MasterRole.create(name:'admin')
MasterRole.create(name:'user')
puts "=--------Role Created Successfully------"


#------------create Master Role------------#
puts "-------Started Adding ADmin User to table----"
User.create(name:'test user', email: "rajat+142@poplify.com", password:'12345678', password_confirmation: '12345678',master_role_id:'1')

puts "=--------Role Created Successfully------"