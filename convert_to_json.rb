require "csv"
require "json"

DB_FILE = "./Movies/watched-movies.csv"
# DB_FILE = "./Books/books.csv"

def convert_to_json(file)
	  CSV.open(file, headers: true).map { |x| x.to_h }.to_json
end

print convert_to_json(DB_FILE)

# ruby convert_to_json.rb | python -m json.tool | pbcopy