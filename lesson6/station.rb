class Station
  include InstanceCounter

  attr_reader :name

  @@objects = []

  def self.all
    @@objects
  end

  def initialize(name)
    @name = name
    @trains = []
    @@objects << self
    register_instance
  end

  def take(train)
    @trains << train unless @trains.include?(train)
  end

  def leave(train)
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

end
