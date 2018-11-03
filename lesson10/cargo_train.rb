# Railroad cargo train
class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :route, :type, Route
  validate :current_station, :type, Station
  validate :carriages, :each_type, CargoCarriage

  def self.objects
    superclass.objects
  end

  def type
    'cargo'
  end
end
