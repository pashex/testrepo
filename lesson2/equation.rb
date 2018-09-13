def solve_equation(a, b, c)
  return puts("Выражение не является уравнением. Ответа нет") if a == 0 && b == 0
  return puts("Уравнение не является квадратным. x=#{-c / b}") if a == 0

  d = b ** 2 - 4 * a * c
  return puts("Корней уравнения нет. D=#{d}") if d < 0
  return puts("D=0, корень один x=#{-b / (2 * a)}") if d == 0

  sqrt_d = Math.sqrt(d)
  x1 = (-b + sqrt_d) / (2 * a)
  x2 = (-b - sqrt_d) / (2 * a)
  puts "D=#{d}, корни уравнения x1=#{x1}; x2=#{x2}"
end

ks = []
%w(a b c).each do |coeff_name|
  puts "Введите коэффициент '#{coeff_name}' уравнения:"
  ks << gets.to_f
end
solve_equation(*ks)



