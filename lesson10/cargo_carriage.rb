# Railroad cargo carriage
class CargoCarriage < Carriage
  attr_reader :volume, :taken_volume
  alias taken taken_volume

  validate :volume, :range, 5, 1000

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
end
