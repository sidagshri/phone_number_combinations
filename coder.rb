class Coder
	@@NUMBER_TO_CHARACTER = {2 => %w(A B C), 3 => %w(D E F), 4 => %w(G H I), 5 => %w(J K L), 6 => %w(M N O), 7 => %w(P Q R S), 8 => %w(T U V), 9 => %w(W X Y Z) }
	@@CHARACTER_TO_NUMBER = { 'A' => 2, 'B' => 2, 'C' => 2, 
		'D' => 3, 'E' => 3, 'F' => 3, 
		'G' => 4, 'H' => 4, 'I' => 4, 
		'J' => 5, 'K' => 5, 'L' => 5, 
		'M' => 6, 'N' => 6, 'O' => 6, 
		'P' => 7, 'Q' => 7, 'R' => 7, 'S' => 7, 
		'T' => 8, 'U' => 8, 'V' => 8, 
		'W' => 9, 'X' => 9, 'Y' => 9, 'Z' => 9}
		
	def initialize
		
	end
	
	def search num
		@number = num
		num_string = number_to_string num
		str = []
		idx = [0,0,0,0,0,0,0,0,0,0]
		idxa = []		
		combinations = 1
		ns.each {|x| combinations = combinations * x.length }
		
		resetter = 9
		starting_characters = num_string[0]
		ending_characters = num_string[9]
		dwords = []
		fgex = /^(#{starting_characters.join('|')}).*(#{ending_characters.join('|')})/
		sgex = /^(#{starting_characters.join('|')})(.*)/
		egex = /.*(#{ending_characters.join('|')})$/
		
	end
	
	def number_to_string n
		n.to_s.split('').map do |x|
			fetch_character(x.to_i)
		end
    end
    
	def fetch_number c
		@@CHARACTER_TO_NUMBER[c]
	end
	
	def fetch_character n
		@@NUMBER_TO_CHARACTER[n]
	end
end
