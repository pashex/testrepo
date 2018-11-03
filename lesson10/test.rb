require_relative 'dummy_classes.rb'
require_relative 'accessors.rb'
require_relative 'validation.rb'
require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'carriage.rb'
require_relative 'passenger_carriage.rb'
require_relative 'cargo_carriage.rb'
require_relative 'history_object.rb'

stations = %w[Уфа Аша Кропачёво Златоуст Миасс Челябинск].map do |name|
  Station.new(name)
end

puts stations.map(&:name)

other_station = Station.new('Москва')

route = Route.new(stations.first, stations.last)
stations[1..-2].each_with_index do |station, index|
  route.add_station_at!(index + 2, station)
end

route.show_stations

# route.add_station_at!(0, other_station)
# route.show_stations

route.add_station_at!(3, other_station)
route.show_stations

# route.remove_station!(stations.first)
# route.show_stations

# route.remove_station!(stations.last)
# route.show_stations

route.remove_station!(other_station)
route.show_stations

passenger_trains = ['ааа-13', '123-59', 'ббб21'].map do |number|
  PassengerTrain.new(number)
end

cargo_trains = ['12648', '123-aa'].map { |number| CargoTrain.new(number) }

train = passenger_trains[0]

train.inc_speed(10)
puts train.speed

passenger_carriage = PassengerCarriage.new('ABP1', 36)
# cargo_carriage = CargoCarriage.new('ABT1', 100)

# puts train.carriage_count
# train.attach!(passenger_carriage)
# puts train.carriage_count

train.stop
train.attach!(passenger_carriage)
puts train.carriage_count

train.detach!
puts train.carriage_count

# train.attach!(cargo_carriage)
# puts train.carriage_count

train.detach!
puts train.carriage_count

puts passenger_trains.map(&:number)
puts cargo_trains.map(&:number)

train.route = route
puts train.inspect

puts [
  train.prev_station, train.current_station, train.next_station
].compact.map(&:name).join(', ')

train.move(-1)
puts [
  train.prev_station, train.current_station, train.next_station
].compact.map(&:name).join(', ')

train.move(1)
puts [
  train.prev_station, train.current_station, train.next_station
].compact.map(&:name).join(', ')

train.move(1)
puts [
  train.prev_station, train.current_station, train.next_station
].compact.map(&:name).join(', ')

cargo_trains.each { |t| t.route = route }
passenger_trains.each { |t| t.route = route }

puts route.first_station.trains.map(&:number)
puts

puts route.first_station.trains('passenger').map(&:number)

puts

puts route.first_station.trains('cargo').map(&:number)

puts

puts route.first_station.trains_count('passenger')
puts route.first_station.trains_count('cargo')
puts

train1 = Train.find('ааа-13')
puts train1.number
train1.mfr_name = 'УралВагонЗавод'
puts train1.mfr_name

train2 = Train.find('123-aa')
train2.mfr_name = 'УралВагонЗавод-2'
puts train2.mfr_name
puts train1.mfr_name

carriage = PassengerCarriage.new('ABУ1', 54)
carriage.mfr_name = 'УралВагонЗавод'
puts carriage.mfr_name

all_stations = Station.all
puts "Все созданные станции: #{all_stations.map(&:name).join(', ')}"

puts "Количество экземлпяров класса Train: #{Train.instances}"
puts "Количество экземлпяров класса PassengerTrain: #{PassengerTrain.instances}"
puts "Количество экземлпяров класса CargoTrain: #{CargoTrain.instances}"
puts "Количество экземлпяров класса Station: #{Station.instances}"
puts "Количество экземлпяров класса Route: #{Route.instances}"

puts '============================================================='

history_object = HistoryObject.new
puts history_object.a.inspect
puts history_object.b.inspect

puts history_object.a_history.inspect
puts history_object.b_history.inspect

history_object.a = 5
puts history_object.a.inspect
puts history_object.a_history.inspect
history_object.a = 6
puts history_object.a_history.inspect
history_object.a = 7
puts history_object.a_history.inspect
history_object.b = 1
puts history_object.b_history.inspect

puts history_object.c.inspect
history_object.c = 'string'
puts history_object.c.inspect

begin
  history_object.c = 5
rescue Accessors::TypeError => e
  puts "Error: #{e}"
end
