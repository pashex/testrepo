vowels = ['а', 'о', 'у', 'ы', 'э', 'я', 'ё', 'ю', 'и', 'е']
alphabet = [('а'..'е').to_a, 'ё', ('ж'..'я').to_a].flatten
puts alphabet.inspect
hash = vowels.map { |vowel| [vowel, alphabet.index(vowel) + 1] }.to_h
puts hash

