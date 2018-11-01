class CargoCarriage < Carriage
  attr_reader :volume, :taken_volume

  def initialize(uid, volume)
    @volume = volume.to_f
    @taken_volume = 0
    super uid
  end

  def type
    'cargo'
  end

  def take_volume!(use_volume)
    raise Validation::Error.new('Нельзя занять больше, чем объём вагона') if taken_volume + use_volume > volume
    self.taken_volume += use_volume
  end

  def free_volume
    volume - taken_volume
  end

  private

  attr_writer :taken_volume

  def validate!
    super
    raise Validation::Error.new('Объем вагона должен быть не менее 5 и не более 1000') if volume < 5 || volume > 1000
  end
end
