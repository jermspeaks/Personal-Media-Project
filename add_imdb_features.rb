require 'filmbuff'
require 'csv'

db_file = "./watched-movies.csv"
new_db_file = "./sample.csv"
movie_array = []

# Movie Object
class Movie
  attr_accessor :title, :imdb_link, :imdb_id, :date, :tagline, :plot, :runtime, :rating, :votes, :poster_url, :genres, :release_date
  def initialize(args = {})
    @title = args['movie_title']
    @imdb_link = args['imdb_link']
    @imdb_id = args['imdb_id']
    @date = args['date']
    @tagline = args['tagline']
    @plot = args['plot']
    @runtime = args['runtime']
    @rating = args['rating']
    @votes = args['votes']
    @poster_url = args['poster_url']
    @genres = args['genres']
    @release_date = args['release_date']
  end
end

# Read through CSV file and push movie into movie_array
def read_csv(file, movie_array)
  imdb = FilmBuff::IMDb.new

  CSV.foreach(file, :headers => true) do |row|
    title = row['movie_title']
    date = row['watched_date']
    imdb_link = row['imdb_link']
    imdb_id = row['imdb_id']

    begin
      record = imdb.find_by_id(imdb_id)

      movie = Movie.new({
        'movie_title' => record.title,
        'imdb_link' => imdb_link,
        'imdb_id' => imdb_id,
        'date' => date,
        'tagline' => record.tagline,
        'plot' => record.plot,
        'runtime' => record.runtime,
        'rating' => record.rating,
        'votes' => record.votes,
        'poster_url' => record.poster_url,
        'genres' => record.genres.join(", "),
        'release_date' => record.release_date
      })

      puts "Title: #{movie.title}, Release Date: #{movie.release_date}"
    rescue
      movie = Movie.new({
        'movie_title' => title,
        'imdb_link' => imdb_link,
        'imdb_id' => imdb_id,
        'date' => date
      })
      puts "Something went wrong for #{movie.title}"
    end

    movie_array.push(movie)
  end
end

# Create the new csv file
def create_new_csv(file, movie_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["movie_title", "imdb_link", "imdb_id", "watched_date", "tagline", "plot", "runtime", "rating", "votes", "poster_url", "genres", "release_date"]) do |csv|
    movie_array.each do |movie|
      csv << [movie.title, movie.imdb_link, movie.imdb_id, movie.date, movie.tagline, movie.plot, movie.runtime, movie.rating, movie.votes, movie.poster_url, movie.genres, movie.release_date]
    end
  end
end

# read_csv(db_file, movie_array)
# create_new_csv(new_db_file, movie_array)
# puts movie_array
imdb = FilmBuff::IMDb.new
movie = imdb.find_by_id('tt0047437')
print [movie.title, "http://www.imdb.com/title/tt0047437", "tt0047437", "03/2013", movie.tagline, movie.plot, movie.runtime, movie.rating, movie.votes, movie.poster_url, movie.genres.join(", "), movie.release_date].join(",")



