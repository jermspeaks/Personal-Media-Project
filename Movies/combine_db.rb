require 'csv'

db_file = "./watched-movies.csv"
other_db_file = "./new-watched-movies.csv"
new_db_file = "./new-sample.csv"
movie_array = []

# Movie Object
class Movie
  attr_accessor :title, :imdb_link, :date
  def initialize(args = {})
    @title = args['movie_title']
    @imdb_link = args['imdb_link']
    @date = args['date']
  end
end

# Read through CSV file and push movie into movie_array
def read_csv(file, other_file, movie_array)
  CSV.foreach(file, :headers => true) do |row|
    title = row['movie_title']
    date = row['watched_date']
    # puts "#{title}: #{date}"
    movie_array.push(Movie.new({
        'movie_title' => title,
        'date' => date
      }))
  end

  CSV.foreach(other_file, :headers => true) do |row|
    movie_array.any? do |movie| 
      if movie.title == row['movie_title']
        movie.imdb_link = row['imdb_link']
      end

      puts "Imported #{movie.title}, #{movie.imdb_link}, watched #{movie.date}"
    end
  end
end

# Create the new csv file
def create_new_csv(file, movie_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["movie_title", "imdb_link", "watched_date"]) do |csv|
    movie_array.each do |movie|
      csv << [movie.title, movie.imdb_link, movie.date]
    end
  end
end

read_csv(db_file, other_db_file, movie_array)
create_new_csv(new_db_file, movie_array)
