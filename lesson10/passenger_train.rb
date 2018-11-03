# Railroad passenger train
class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :route, :type, Route
  validate :current_station, :type, Station
  validate :carriages, :each_type, PassengerCarriage

  def self.objects
    superclass.objects
  end

  def type
    'passenger'
  end
end
