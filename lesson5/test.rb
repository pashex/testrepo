load 'station.rb'
load 'route.rb'
load 'train.rb'

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

passenger_trains = [13, 59, 211].map { |number| Train.new(number, 'passenger', rand(15) + 5) }
freight_trains = [648, 950].map { |number| Train.new(number, 'freight', 30) }

puts passenger_trains
puts freight_trains

train = passenger_trains[0]
train.route = route
puts train.inspect

train.inc_speed(10)
puts train.speed

puts train.carriage_count
train.attach
puts train.carriage_count

train.stop
train.attach
puts train.carriage_count

train.detach
puts train.carriage_count

puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')
train.move(-1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

train.move(1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

train.move(1)
puts [train.prev_station, train.current_station, train.next_station].compact.join(', ')

freight_trains.each { |train| train.route = route }
passenger_trains.each { |train| train.route = route }

puts route.first_station.trains
puts

puts route.first_station.trains('passenger')
puts

puts route.first_station.trains('freight')
puts

puts route.first_station.trains_count('passenger')
puts route.first_station.trains_count('freight')
puts

passenger_trains.each { |train| puts "#{train}, #{train.current_station}" }





