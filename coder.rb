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
		@c_array = number_to_string
		@combinations = make_combinations
		fetch_and_process
	end
		
	def old_search num
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
		
		c_a = c_a.reject {|x| next if x.is_a?(String); c_a.include?(x.join('')) }
		
		combinations.times do |z|
			break if z == 1
		    #break if z == 50
		    #puts '----'
		    #puts z
			s = ""			
			#puts "before:: #{idx}"
			num_strings.each_with_index do |x, i|
			  #puts "#{ns[i]}"
			  j = idx[i]			  
			  s += x[j]			  
			end			
			#puts "#{s}"
			#puts resetter
			idx[resetter] = (idx[resetter].next % ns[resetter].length)
			#puts "after:: #{idx}"
			if idx[resetter] == 0
				#idx[resetter] = 0 #idx[resetter].next % ns[resetter].length
				#resetter = resetter - 1				
			#	puts "adjusting"
				idx.each_with_index do |idxi, m|
			#	    puts "#{idx}"					
					if idx[resetter] == 0
						resetter -= 1 
						idx[resetter] = idx[resetter].next % ns[resetter].length						
					end	
					break if idx[resetter] > 0				
				end				
				resetter = 9
			#	puts "after adjusting :: #{idx}"
			end						
			str << s
			#File.open(filename, 'a') do |file|
			#	file.puts s
			#end
		end
		
	end

private	
	
	def fetch_and_process
		words = []
		@combinations.each_with_index do |c, i|
			gex_component = c.collect {|x| "(^#{x}$)\n"}.join('|')
			word_combinations = @dictionary.fetch_words.scan(/(?:#{gex_component})/).uniq
						
			h = {0 => [], 1 => []}
			word_combinations.each {|x| !x.first.nil? ? (h[0] += x.compact) : (h[1] += x.compact) }				
			word_arr = h.values				
			words += h[0].product(h[1]).map {|x| x unless words.include?(x.join(''))}.compact unless word_arr.include? []
			
		end
		words
	end
	
	def make_combinations
		combination_arr = []
		##10
		s = ""
		@c_array.each {|x| s += "[#{x.join('|')}]" }
		combination_arr << [s]
		##37
		a = []
		s = ""
		@c_array.values_at(0..2).each {|x| s += "[#{x.join('|')}]" }
		a << s
		s = ""
		@c_array.values_at(3..9).each {|x| s += "[#{x.join('|')}]" }
		a << s
		combination_arr << a
		##46
		a = []
		s = ""
		@c_array.values_at(0..3).each {|x| s += "[#{x.join('|')}]" }
		a << s
		s = ""
		@c_array.values_at(4..9).each {|x| s += "[#{x.join('|')}]" }
		a << s
		combination_arr << a
		
		##55
		a = []
		s = ""
		@c_array.values_at(0..4).each {|x| s += "[#{x.join('|')}]" }
		a << s
		s = ""
		@c_array.values_at(5..9).each {|x| s += "[#{x.join('|')}]" }
		a << s
		combination_arr << a
		
		##64
		a = []
		s = ""
		@c_array.values_at(0..5).each {|x| s += "[#{x.join('|')}]" }
		a << s
		s = ""
		@c_array.values_at(6..9).each {|x| s += "[#{x.join('|')}]" }
		a << s
		combination_arr << a
		
		##73
		a = []
		s = ""
		@c_array.values_at(0..6).each {|x| s += "[#{x.join('|')}]" }
		a << s
		s = ""
		@c_array.values_at(7..9).each {|x| s += "[#{x.join('|')}]" }
		a << s
		
		combination_arr << a
		combination_arr
	end
	
	def string_to_number s
		a = []
		s.split('').each do |x|
			a << fetch_number(x)
		end
		a.join('')
	end
	
	def number_to_string 
		@number.to_s.split('').map do |x|
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
