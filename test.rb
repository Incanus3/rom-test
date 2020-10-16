APP_ROOT = File.expand_path(__dir__)

$LOAD_PATH.unshift(APP_ROOT)

require 'app/dependencies'

App::Dependencies.start(:persistence)

db = App::Dependencies[:db]
sep = '=' * 80

client_tuples = [
  {
    first_name:        "Jane",
    last_name:         'Doe',
    municipality:      'Prague',
    zip_code:          '10100',
    email:             'john.doe@gmail.com',
    phone_number:      '+420602222222',
    insurance_number:  '1234567890',
    insurance_company: '111',
  },
  {
    first_name:        "John",
    last_name:         'Doe',
    municipality:      'Vienna',
    zip_code:          '25164',
    email:             'jane.doe@pm.me',
    phone_number:      '+421123456789',
    insurance_number:  '0987654321',
    insurance_company: '222',
  }
]

db.registrations.delete_all()
db.clients.delete_all()

john, jane = db.clients.create_many(client_tuples)
puts sep
puts "john: #{john.inspect}"
puts "jane: #{jane.inspect}"

registration_tuples = [
  { client_id: john.id, requestor_type: "samopl", exam_type: "pl",    exam_date: '2020-10-20', registered_at: Time.now },
  { client_id: jane.id, requestor_type: "khs",    exam_type: "rapid", exam_date: '2020-10-30', registered_at: Time.now },
]

johns_reg, janes_reg = db.registrations.create_many(registration_tuples)
puts sep
puts "john's registration: #{johns_reg.inspect}"
puts "jane's registration: #{janes_reg.inspect}"

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
puts "jane's registration 2 with client:"
registration_with_client = db.registrations.by_id(janes_reg.id).combine(:client).one!
pp registration_with_client
pp registration_with_client.client
