require "csv"
require "json"

DB_FILE = "../Movies/watched-movies.csv"

def convert_to_json(file)
  CSV.open(file, headers: true).map { |x| x.to_h }.to_json
end

print convert_to_json(DB_FILE)