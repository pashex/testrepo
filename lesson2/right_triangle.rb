sides = []
3.times.each do |n|
  puts "Введите #{n + 1} сторону треугольника:"
  sides << gets.to_f
end

max_side, max_side_index = sides.each_with_index.max
puts "Самая большая - #{max_side_index + 1} сторона: #{max_side}"

sides.delete_at(max_side_index)

if sides[0] ** 2 + sides[1] ** 2 == max_side ** 2
  puts "Треугольник прямоугольный"
else
  puts "Треугольник не прямоугольный"
end

if sides[0] == sides[1]
  if sides[1] == max_side
    puts "Треугольник равносторонний"
  else
    puts "Треугольник равнобедренный"
  end
end

