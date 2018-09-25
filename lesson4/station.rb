class Station
  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    @trains << train unless @trains.include?(train)
  end

  def send(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    if type
      @trains.select { |train| train.type == type }
    else
      @trains
    end
  end

  def trains_count(type = nil)
    trains(type).count
  end

  def to_s
    @name
  end
end
