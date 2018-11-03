# Railroad station
class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /\A[а-яё]{3,}([\-\s]?[а-яё]{3,})?(\s\d)?\z/i

  attr_reader :name

  validate :name, :presence
  validate :name, :format, NAME_FORMAT
  validate :trains, :each_type, Train

  @objects = []

  class << self
    attr_reader :objects
    alias all objects
  end

  def initialize(name)
    @name = name.to_s.strip
    @trains = []
    validate!
    self.class.objects << self
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

  def each_train
    @trains.each { |train| yield train }
  end
end
