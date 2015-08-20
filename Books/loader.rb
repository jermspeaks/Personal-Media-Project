require "csv"
require "goodreads"

DB_FILE = "./list.csv"
EXPORT_DB_FILE = "./export.csv"
class Book
	attr_accessor :title, :isbn, :description
  def initialize(args = {})
    @title = args['book_title']
    @isbn = args['isbn']
    @description = args['description']
  end
end

def create_goodreads_client
  Goodreads::Client.new(:api_key => 'Z0CC2Sg1ZL5I9vHbHrdBfg', :api_secret => 'LZP8vOsOMS5g0YdbiNW1XGk3SpYLezQYi3DmI3UZo')
end

def fetch_books(books)
  book_objects = []
  goodreads_client = create_goodreads_client()
    books.each do |title|
      begin
        puts "Looking for: #{title}..."
        goodreads_book = goodreads_client.book_by_title(title)
        created_book = Book.new({
          'book_title' => goodreads_book.title,
          'isbn' => goodreads_book.isbn,
          'description' => goodreads_book.description,
        })
        book_objects << created_book
      rescue
        book_objects << Book.new({
          'book_title' => title
        })
        puts "Couldn't find book #{title}"
      end
    end
  return book_objects
end

# Read through CSV file and push movie into movie_array
def read_csv(file)
  reading_list = []
  CSV.foreach(file, :headers => true) do |row|
    reading_list << row['title']
  end
  reading_list
end

def export_csv(file, books_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["book_title", "isbn", "description"]) do |csv|
    books_array.each do |book|
      puts "exporting #{book.title}"
      csv << [book.title, book.isbn, book.description]
    end
  end
end


# test_book_array = ['Gone With The Wind']
# bookshelf = fetch_books(test_book_array)
#
book_array = read_csv(DB_FILE)
bookshelf = fetch_books(book_array)
# bookshelf.each do |book|
#   puts "Title: #{book.title} | ISBN: #{book.isbn}"
#   puts "Description: #{book.description}"
# end
export_csv(EXPORT_DB_FILE, bookshelf)
