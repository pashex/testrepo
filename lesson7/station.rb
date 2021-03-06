class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /\A[а-яё]{3,}([\-\s]?[а-яё]{3,})?(\s\d)?\z/i

  attr_reader :name

  @@objects = []

  def self.all
    @@objects
  end

  def initialize(name)
    @name = name.to_s.strip
    @trains = []
    validate!
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

  private

  def validate!
    raise Validation::Error.new('Название станции не может быть пустым') if name.length.zero?
    raise Validation::Error.new('Название станции должно быть не менее 2-х символов') if name.length < 2
    raise Validation::Error.new('Название станции в неверном формате') if name !~ NAME_FORMAT
  end
end
