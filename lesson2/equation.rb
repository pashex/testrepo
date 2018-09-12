k = {}
%w(a b c).each do |coeff_name|
  puts "Введите коэффициент '#{coeff_name}' уравнения:"
  k[coeff_name] = gets.to_f
end

if k['a'] == 0
  if k['b'] == 0
    puts "Выражение не является уравнением. Ответа нет"
  else
    x = -k['c'] / k['b']
    puts "Уравнение не является квадратным. x=#{x}"
  end
else
  discriminant = k['b'] ** 2 - 4 * k['a'] * k['c']
  if discriminant < 0
    puts "Корней уравнения нет. D=#{discriminant}"
  elsif discriminant == 0
    x = - k['b'] / (2 * k['a'])
    puts "D=0, корень один x=#{x}"
  else
    sqrt_discriminant = Math.sqrt(discriminant)
    x1 = (- k['b'] + sqrt_discriminant) / (2 * k['a'])
    x2 = (- k['b'] - sqrt_discriminant) / (2 * k['a'])
    puts "D=#{discriminant}, корни уравнения x1=#{x1}; x2=#{x2}"
  end
end

