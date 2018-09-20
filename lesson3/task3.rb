fibb_array = [0, 1]
loop do
  new_value = fibb_array[-1] + fibb_array[-2]
  break if new_value > 100
  fibb_array << new_value
end
puts fibb_array.inspect

