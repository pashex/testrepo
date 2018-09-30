require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'carriage.rb'
require_relative 'passenger_carriage.rb'
require_relative 'cargo_carriage.rb'

stations = %w(Уфа Аша Кропачёво Златоуст Миасс Челябинск).map { |name| Station.new(name) }
puts stations

other_station = Station.new('Москва')

route = Route.new(stations.first, stations.last)
stations[1..-2].each_with_index { |station, index| route.add_station_at(index + 1, station) }
puts route

route.add_station_at(0, other_station)
puts route

route.add_station_at(6, other_station)
puts route

route.add_station_at(3, other_station)
puts route

route.remove_station(stations.first)
puts route

route.remove_station(stations.last)
puts route

route.remove_station(other_station)
puts route

passenger_trains = [13, 59, 211].map { |number| PassengerTrain.new(number) }
cargo_trains = [648, 950].map { |number| CargoTrain.new(number) }

train = passenger_trains[0]

train.inc_speed(10)
puts train.speed

passenger_carriage = PassengerCarriage.new
cargo_carriage = CargoCarriage.new

puts train.carriage_count
train.attach(passenger_carriage)
puts train.carriage_count

train.stop
train.attach(passenger_carriage)
puts train.carriage_count

train.detach
puts train.carriage_count

train.attach(cargo_carriage)
puts train.carriage_count

train.detach
puts train.carriage_count

puts passenger_trains
puts cargo_trains

train.route = route
puts train.inspect

puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')
train.move(-1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

train.move(1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

train.move(1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

cargo_trains.each { |train| train.route = route }
passenger_trains.each { |train| train.route = route }

puts route.first_station.trains
puts

puts route.first_station.trains('passenger')
puts

puts route.first_station.trains('cargo')
puts

puts route.first_station.trains_count('passenger')
puts route.first_station.trains_count('cargo')
puts

passenger_trains.each { |train| puts [train, train.current_station].compact.join(', ') }





