def leap_year?(year)
  return unless year % 4 == 0
  return if year % 100 == 0 && year % 400 != 0
  true
end

month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

day, month, year = ['Введите день', 'Введите месяц', 'Введите год'].map do |question|
  puts question
  gets.chomp.to_i
end

month_days[1] = 29 if leap_year?(year)

if day <= 0 || month <= 0 || month_days[month - 1].to_i < day
  puts "Ошибка даты"
else
  day_number = (1...month).map { |m| month_days[m - 1] }.inject(0, :+) + day
  puts "Порядковый номер дня с начала года: #{day_number}"
end



