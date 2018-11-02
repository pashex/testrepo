# Seed data for Railroad
module Seeder
  private

  def seed_stations(stations_string)
    stations_string.split.map { |name| Station.new(name) }
  end

  def seed_route(stations)
    route = Route.new(stations.first, stations.last)
    stations[1..-2].each_with_index do |station, index|
      route.add_station_at!(index + 2, station)
    end
    route
  end

  def seed_trains(passenger: '', cargo: '')
    trains = passenger.split.map { |number| PassengerTrain.new(number) }
    trains + cargo.split.map { |number| CargoTrain.new(number) }
  end

  def seed_carriages(passenger: '', cargo: '', seats:, volume:)
    carriages = passenger.split.map { |uid| PassengerCarriage.new(uid, seats) }
    carriages + cargo.split.map { |uid| CargoCarriage.new(uid, volume) }
  end

  def attach_carriages(trains, carriages)
    trains.each_with_index do |train, index|
      train.attach!(carriages[index])
    end
  end

  def set_routes(trains, routes)
    trains[0..1].each { |train| train.route = routes[0] }
    trains[2].route = routes[1]
    trains[4..5].each { |train| train.route = routes[1] }
  end
end
