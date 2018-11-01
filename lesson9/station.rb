# Railroad station
class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /\A[а-яё]{3,}([\-\s]?[а-яё]{3,})?(\s\d)?\z/i
  MSG = { empty_name: 'Название станции не может быть пустым',
          error_length: 'Название станции должно быть не менее 2-х символов',
          invalid_format: 'Название станции в неверном формате' }.freeze

  attr_reader :name

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

  private

  def validate!
    validation_fail!(MSG[:empty_name]) if name.length.zero?
    validation_fail!(MSG[:error_length]) if name.length < 2
    validation_fail!(MSG[:invalid_format]) if name !~ NAME_FORMAT
  end
end
