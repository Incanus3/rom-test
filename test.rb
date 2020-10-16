APP_ROOT = File.expand_path(__dir__)

$LOAD_PATH.unshift(APP_ROOT)

require 'app/dependencies'
require 'app/services/registration'
require 'app/services/export'

App::Dependencies.start(:persistence)

db  = App::Dependencies[:db]
sep = '=' * 80

marie_attrs = {
  first_name:        "Marie",
  last_name:         'Doe',
  municipality:      'Prague',
  zip_code:          '10100',
  email:             'marie.doe@gmail.com',
  phone_number:      '+420602222222',
  insurance_number:  '1234567890',
  insurance_company: '111',
}

john_attrs = {
  first_name:        "John",
  last_name:         'Doe',
  municipality:      'Vienna',
  zip_code:          '25164',
  email:             'john.doe@pm.me',
  phone_number:      '+421123456789',
  insurance_number:  '0987654321',
  insurance_company: '222',
}

db.registrations.delete_all()
db.clients.delete_all()

db.clients.create(marie_attrs)

p App::Services::Registration.perform(marie_attrs.merge({
  last_name:         "Currie", # will get updated
  requestor_type:    "samopl",
  exam_type:         "pl",
  exam_date:         '2020-10-20',
}))

p App::Services::Registration.perform(john_attrs.merge({
  requestor_type:    "khs",
  exam_type:         "rapid",
  exam_date:         '2020-10-30',
}))

puts sep
puts "all clients:"
pp db.clients.all
puts sep
puts "all registrations:"
pp db.registrations.all
puts sep
puts "john:"
pp db.clients.by_name(first: 'John', last: 'Doe')
puts sep
puts "john with his registrations:"
pp db.clients.with_registrations.by_name(first: 'John', last: 'Doe').one!
puts sep
puts "marie's registration 2 with client:"
registration_with_client = db.registrations.with_clients.by_date('2020-10-20').one!
pp registration_with_client
pp registration_with_client.client

puts sep
result = App::Services::Export.perform
p result.success?
result.bind { |csv| puts csv }
