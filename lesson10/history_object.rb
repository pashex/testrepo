# Class for testing history accessor
class HistoryObject
  include Accessors

  attr_accessor_with_history :a, :b
  strong_attr_accessor :c, String
end
