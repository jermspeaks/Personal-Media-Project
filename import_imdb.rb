require 'filmbuff'
require 'csv'

imdb = FilmBuff::IMDb.new

db_file = "./sample.csv"
new_db_file = "./new-sample.csv"
movie_array = []

# Movie Object
class Movie
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
    if row['movie_title']
      begin
        movie = imdb.find_by_title(row['movie_title'])
        if movie.imdb_id
          movie_array.push(Movie.new({
            'movie_title' => row['movie_title'],
            'imdb_id' => imdb_id
          }))
        end
      rescue
        puts "Can not find movie #{row['movie_title']}"
        movie_array.push(Movie.new({
          'movie_title' => row['movie_title']
        }))
      end
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
create_new_csv(new_db_file, movie_array)