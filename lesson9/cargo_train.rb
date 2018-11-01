# Railroad cargo train
class CargoTrain < Train
  def self.objects
    superclass.objects
  end

  def type
    'cargo'
  end
end
