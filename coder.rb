require File.join(File.dirname(__FILE__), "dictionary", "dictionary")

class Coder
	def initialize options = {}
		@dictionary = Dictionary.new #.fetch_words		
		@enable_full_search = options[:enable_full_search] || false
	end

	def search n
		# validate number
		status, msg = valid_number n
		return msg unless status
		
		@number = n
		@c_array = number_to_string n
		@combinations = make_combinations
		fetch_and_process		
	end
	
	private 
	
	def valid_number n
		number = n.to_s
		return false, "Must be a 10 digit number only" if number.length != 10
		return false, "Must not include 0 & 1" unless (number.split('') & ['0','1']).empty?
		return true
	end
	
	def fetch_and_process
		words = []
		@combinations.each_with_index do |c, i|
			gex_component = c.collect {|x| "(^#{x}$)\n"}.join('|')
			word_combinations = @dictionary.fetch_words.scan(/(?:#{gex_component})/).uniq
			
			if c.length == 1
				words += word_combinations.flatten
			elsif c.length == 2
				h = {0 => [], 1 => []}
				word_combinations.each {|x| !x.first.nil? ? (h[0] += x.compact) : (h[1] += x.compact) }
				
				word_arr = h.values
				if i != 3
					words += h[0].product(h[1]).map {|x| x unless words.include?(x.join(''))}.compact unless word_arr.include? []				
				elsif i == 3
					unless word_arr.include? []
						words += h[0].product(h[1]).map {|x| x unless words.include?(x.join(''))}.compact 				
					else
						## this case is added just if a number has equal halves 
						#  for example; 46559 46559  which can possibly be made as 
						#   [["HOLK", "WHOLLY"], ["GOLLY", "GOLLY"], ["GOLLY", "HOLLY"], ["HOLLY", "GOLLY"], ["HOLLY", "HOLLY"]]
						#  instead of just [["HOLK", "WHOLLY"], ["GOLLY", "HOLLY"]]
						##
						words += word_arr.flatten.uniq.repeated_permutation(2).to_a.map {|x| x unless (words.include?(x.join('')) || words.include?([x.join('')]))}.compact if @number.to_s[0..4] == @number.to_s[5..9]
					end	
				end
			elsif c.length == 3 # case hits only if flag enable_full_search was set true
				h = {0 => [], 1 => [], 2 => []}
				word_combinations.each {|x| !x.first.nil? ? (h[0] += x.compact) : !x.last.nil? ? (h[2] += x.compact) : (h[1] += x.compact)}
				word_arr = h.values				
				words += h[0].product(h[1].product(h[2])).map {|x| x.flatten }.map {|x| x unless (words.include?(x.join('')) || words.include?([x.join('')]))}.compact unless word_arr.include? []							
			end
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
		## if this flag is true, allow to search for 3 words combinations also
		if @enable_full_search
			##334
			a = []
			s = ""
			@c_array.values_at(0..2).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(3..5).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(6..9).each {|x| s += "[#{x.join('|')}]" }
			a << s
		
			##343
			a = []
			s = ""
			@c_array.values_at(0..2).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(3..6).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(7..9).each {|x| s += "[#{x.join('|')}]" }
			a << s
			
			##433
			a = []
			s = ""
			@c_array.values_at(0..3).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(4..6).each {|x| s += "[#{x.join('|')}]" }
			a << s
			s = ""
			@c_array.values_at(7..9).each {|x| s += "[#{x.join('|')}]" }
			a << s
		end
		combination_arr << a
		combination_arr
	end

	def number_to_string n
		n.to_s.split('').map do |x|
			fetch_character(x.to_i)
		end
    end
    
	def string_to_number s	  
	  s.split('').map do |x|
	    fetch_number(x)
	  end.join('')
    end
    
	def fetch_number c
		@@CHARACTER_TO_NUMBER[c]
	end
	
	def fetch_character n
		@@NUMBER_TO_CHARACTER[n]
	end
	
	@@NUMBER_TO_CHARACTER = {2 => %w(A B C), 3 => %w(D E F), 4 => %w(G H I), 5 => %w(J K L), 6 => %w(M N O), 7 => %w(P Q R S), 8 => %w(T U V), 9 => %w(W X Y Z) }
	@@CHARACTER_TO_NUMBER = { 'A' => 2, 'B' => 2, 'C' => 2, 
		'D' => 3, 'E' => 3, 'F' => 3, 
		'G' => 4, 'H' => 4, 'I' => 4, 
		'J' => 5, 'K' => 5, 'L' => 5, 
		'M' => 6, 'N' => 6, 'O' => 6, 
		'P' => 7, 'Q' => 7, 'R' => 7, 'S' => 7, 
		'T' => 8, 'U' => 8, 'V' => 8, 
		'W' => 9, 'X' => 9, 'Y' => 9, 'Z' => 9}
end

describe Coder do
  describe 'Testing search #test case 1' do
    it 'testing with 6686787825' do
      cdr = Coder.new      
      expect(cdr.search 6686787825).to eq(["MOTORTRUCK", ["NOUN", "STRUCK"], ["ONTO", "STRUCK"], ["MOTOR", "USUAL"], ["NOUNS", "TRUCK"], ["NOUNS", "USUAL"]])
    end
  end  
  describe 'Testing search #test case 2' do
    it 'testing with 2282668687' do
      cdr = Coder.new      
      expect(cdr.search 2282668687).to eq(["CATAMOUNTS", ["ACT", "AMOUNTS"], ["ACT", "CONTOUR"], ["BAT", "AMOUNTS"], ["BAT", "CONTOUR"], ["CAT", "CONTOUR"], ["ACTA", "MOUNTS"]])
    end
  end
end
