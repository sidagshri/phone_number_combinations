require File.join(File.dirname(__FILE__), "dictionary", "dictionary")

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
		@dictionary = Dictionary.new
	end
	
	def search num
		@number = num
		number_string = num.to_s
		num_strings = number_to_string num
		str = []
		idx = [0,0,0,0,0,0,0,0,0,0]
		idxa = []		
		combinations = 1
		
		num_strings.each {|x| combinations = combinations * x.length }
		
		resetter = 9
		starting_characters = num_strings[0]
		ending_characters = num_strings[9]
		dwords = []
		fgex = /^(#{starting_characters.join('|')}).*(#{ending_characters.join('|')})/
		sgex = /^(#{starting_characters.join('|')})(.*)/
		egex = /.*(#{ending_characters.join('|')})$/
		
		ls = []
		c_a = []
		
		@dictionary.fetch_words.each_with_index do |x, ind|
		    x = x.strip
		    l = x.length
		    
			if (l == 10 && x.match(fgex)) 
			  s1 = string_to_number(x)
			  c_a << x if s1 == number_string
			elsif (l < 9 && (x.match(sgex) || x.match(egex)))
			  dwords << x
			  ls << l
			end
		end
		
		hwords = Hash.new {|h,k| h[k] = [] }
		lmn = ls.min
		lmx = ls.max
		
		lns = []
		dwords = dwords.map do |x| 
		    l = x.length
			s1 = string_to_number(x) 
			if (l <= (lmx - lmn) && number_string.match(/(.*)#{s1}(.*)/))			    
			    hwords[s1] << x			    
			    lns << l
				x
			end
		end.compact.uniq
		
	end
	
	def string_to_number s
		a = []
		s.split('').each do |x|
			a << fetch_number(x)
		end
		a.join('')
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
