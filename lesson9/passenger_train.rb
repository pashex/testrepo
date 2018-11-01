# Railroad passenger train
class PassengerTrain < Train
  def self.objects
    superclass.objects
  end

  def type
    'passenger'
  end
end
