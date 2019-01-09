class Dictionary
	def initialize
		@dictionary  = 'dictionary.txt'
	end
	
	def fetch_words
		words = []
		File.open(@dictionary, 'r').each do |x|
			words << x.strip
		end
		words	
	end
end
