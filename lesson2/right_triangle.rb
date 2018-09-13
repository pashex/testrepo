def triangle?(a, b, c)
  a + b > c && b + c > a && a + c > b
end

def right?(*sides)
  max_side, max_side_index = sides.each_with_index.max
  sides.delete_at max_side_index
  sides[0] ** 2 + sides[1] ** 2 == max_side ** 2
end

def isosceles?(a, b, c)
  [a, b, c].uniq.length == 2
end

def equilateral?(sides)
  sides.uniq.one?
end

def test_triangle(sides)
  return puts("Это не треугольник") unless triangle?(*sides)
  return puts("Треугольник прямоугольный") if right?(*sides)
  return puts("Треугольник равносторонний") if equilateral?(sides)
  return puts("Треугольник равнобедренный") if isosceles?(*sides)
  puts "Треугольник не является ни прямоугольным, ни равнобедренным"
end

sides = []
3.times.each do |n|
  puts "Введите #{n + 1} сторону треугольника:"
  sides << gets.to_f
end

test_triangle(sides)


