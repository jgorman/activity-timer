# This file should contain all the record creation needed to seed
# the database with its default values.
#
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).

admin = User.new(
  email: 'admin@admin.com',
  first_name: 'Super',
  last_name: 'Admin',
  role_s: 'admin',
  password: 'changeme'
)
admin.save

User.guest_history
