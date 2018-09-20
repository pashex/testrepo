names = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)
days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
months = names.zip(days).to_h

months.each { |name, days| puts(name) if days == 30 }
