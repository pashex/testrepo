def leap_year?(year)
  year % 4 == 0 && year % 100 != 0 || year % 400 == 0
end

month_days = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

day, month, year = ['Введите день', 'Введите месяц', 'Введите год'].map do |question|
  puts question
  gets.chomp.to_i
end

month_days[2] = 29 if leap_year?(year)

if day <= 0 || month <= 0 || month_days[month].to_i < day
  puts "Ошибка даты"
else
  day_number = month_days[1...month].inject(0, :+) + day
  puts "Порядковый номер дня с начала года: #{day_number}"
end



