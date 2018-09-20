my_array = (10..100).map { |number| number if number % 5 == 0 }.compact
puts my_array.inspect
