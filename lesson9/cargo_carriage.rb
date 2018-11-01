# Railroad cargo carriage
class CargoCarriage < Carriage
  MSG = { invalid_volume: 'Объем должен быть больше 4 и не более 1000' }.freeze

  attr_reader :volume, :taken_volume
  alias taken taken_volume

  def initialize(uid, volume)
    @volume = volume.to_f
    @taken_volume = 0
    super uid
  end

  def type
    'cargo'
  end

  def take_volume!(use_volume)
    if taken_volume + use_volume > volume
      raise Validation::Error, 'Нельзя занять больше, чем объём вагона'
    end

    self.taken_volume += use_volume
  end

  def free_volume
    volume - taken_volume
  end
  alias free free_volume

  private

  attr_writer :taken_volume

  def validate!
    super
    validation_fail!(MSG[:invalid_volume]) if volume < 5 || volume > 1000
  end
end
