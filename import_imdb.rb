require 'filmbuff'
require 'csv'

imdb = FilmBuff::IMDb.new

db_file = "./sample.csv"
new_db_file = "./new-sample.csv"
movie_array = []

# Movie Object
class Movie
  attr_accessor :title, :watched_date
  def initialize(args = {})
    @title = args['movie_title']
    @imdb_id = args['imdb_id']
    @watched_date = args['watched_date']
  end

  def create_imdb_link()
    return "http://www.imdb.com/title/#{@imdb_id}"
  end
end

# Read through CSV file and push movie into movie_array
def read_csv(file, movie_array)
  CSV.foreach(file, :headers => true) do |row|
    title = row['movie_title']
    begin
      movie = imdb.find_by_title(row['movie_title'])
      if movie.imdb_id
        movie_array.push(Movie.new({
          'movie_title' => movie.title,
          'imdb_id' => movie.imdb_id
        }))
      end
    rescue
      puts "Can not find movie: #{row['movie_title']}"
      movie_array.push(Movie.new({
        'movie_title' => row['movie_title']
      }))
    end
  end
end

# Create the new csv file
def create_new_csv(file, movie_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["movie_title", "imdb_link"]) do |csv|
    movie_array.each do |movie|
      csv << [movie.title, movie.create_imdb_link()]
    end
  end
end

read_csv(db_file, movie_array)
# create_new_csv(new_db_file, movie_array)
puts movie_array
# movie = Movie.new({
#   'movie_title' => 'Casablanca',
#   'imdb_id' => 'tt0099582',
#   'watched_date' => 'June 2010'
#   })
# puts movie
# puts movie.title
# puts movie.create_imdb_link()
# puts movie.watched_date
