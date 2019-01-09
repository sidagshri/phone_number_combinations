class Dictionary
	def initialize
		file_name = 'dictionary.txt'
		@dictionary =  File.join(File.dirname(__FILE__), file_name)
	end
	
	def fetch_words
		words = []
		File.open(@dictionary, 'r').each {|x| words << x }
		words	
	end
end
