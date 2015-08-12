# require 'filmbuff'
require 'csv'

# imdb = FilmBuff::IMDb.new

db_file = "./watched-movies.csv"
new_db_file = "./sample.csv"
movie_array = []

# Movie Object
class Movie
  attr_accessor :title, :imdb_link, :date
  def initialize(args = {})
    @title = args['movie_title']
    @imdb_link = args['imdb_link']
    @date = args['date']
  end

  def get_imdb_id()
    regex = /http\:\/\/www\.imdb\.com\/title\/(tt.+)/
    match = @imdb_link.match regex
    return match[1]
  end
end

# Read through CSV file and push movie into movie_array
def read_csv(file, movie_array)
  CSV.foreach(file, :headers => true) do |row|
    title = row['movie_title']
    date = row['watched_date']
    imdb_link = row['imdb_link']

    movie_array.push(Movie.new({
      'movie_title' => title,
      'imdb_link' => imdb_link,
      'date' => date
    }))
  end
end

# Create the new csv file
def create_new_csv(file, movie_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["movie_title", "imdb_link", "imdb_id", "watched_date"]) do |csv|
    movie_array.each do |movie|
      csv << [movie.title, movie.imdb_link, movie.get_imdb_id(), movie.date]
    end
  end
end

read_csv(db_file, movie_array)
create_new_csv(new_db_file, movie_array)
# puts movie_array
