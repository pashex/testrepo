puts "Ваше имя?"
name = gets.chomp.capitalize
puts "Ваш рост?"
height = gets.chomp.to_i
weight = height - 110
if weight < 0
  puts "#{name}, ваш вес уже оптимальный!"
else
  puts "#{name}, ваш идеальный вес - #{weight}"
end
