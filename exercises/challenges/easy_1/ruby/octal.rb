# Challenges: Easy 1
# 21 August, 2017
# Exercise 3: Octal

class Octal
	def initialize(input_string)
		@input_string = input_string
	end

	def to_decimal
		return 0 if @input_string =~ /[a-zA-Z89]/
		
		digits = @input_string.reverse.chars.map(&:to_i)
		
		digits.map.with_index do |digit, index|
			digit * 8**index
		end.reduce(:+)
	end
end