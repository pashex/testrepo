goods = {}
loop do
  puts 'Название товара'
  name = gets.chomp
  break if name == 'стоп'
  if goods[name]
    puts "Данный товар уже существует"
    next
  end
  puts 'Цена товара'
  price = gets.chomp.to_f
  puts 'Количество товара'
  count = gets.chomp.to_f
  goods[name] = { price: price, count: count }
end

puts "Товары в корзине: #{goods}"

puts "Сумма по товарам:"
goods_totals = goods.map { |name, info| [name, info[:price] * info[:count]] }.to_h
puts goods_totals.map { |name, price| "#{name}: #{price}" }.join('; ')

total = goods_totals.values.inject(:+)
puts "Сумма всех покупок: #{total}"




