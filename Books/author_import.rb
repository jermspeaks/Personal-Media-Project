require "csv"
require "goodreads"

DB_FILE = "./export-new.csv"
EXPORT_DB_FILE = "./export.csv"
class Book
  attr_accessor :title, :goodreads_id, :isbn, :isbn13, :asin, :image_url, :publication_year, :publication_month, :publication_day, :publisher, :language_code, :description, :work, :num_pages, :book_format, :url, :link, :authors, :series_works
  def initialize(args = {})
    @title = args['book_title']
    @goodreads_id = args['id']
    @isbn = args['isbn']
    @isbn13 = args['isbn13']
    @image_url = args['image_url']
    @publication_year = args['publication_year']
    @publication_month = args['publication_month']
    @publication_day = args['publication_day']
    @publisher = args['publisher']
    @language_code = args['language_code']
    @description = args['description']
    @num_pages = args['num_pages']
    @book_format = args['format']
    @url = args['url']
    @link = args['link']
    @authors = args['authors']
  end
end

def create_goodreads_client
  Goodreads::Client.new(:api_key => 'Z0CC2Sg1ZL5I9vHbHrdBfg', :api_secret => 'LZP8vOsOMS5g0YdbiNW1XGk3SpYLezQYi3DmI3UZo')
end

def add_book_details(books)
  goodreads_client = create_goodreads_client()
  books.map do |book|
    if book.authors == ", , , , , , , , "
      puts "Invalid Author for #{book.title}"
      puts "#{book.authors}"
      if book.isbn
        goodreads_book = goodreads_client.book_by_isbn(book.isbn)
      else
        goodreads_book = goodreads_client.book_by_title(book.title)
      end

      book.authors = goodreads_book.authors.author.name
      # authors = goodreads_book.authors.author.map do |author|
      #   author.name if author.respond_to?(:name)
      # end
      # book.authors = authors.join(", ")
      # puts book.authors
    end

    book
  end
end

# Read through CSV file and push book into reading_list
def read_csv(file)
  reading_list = []
  CSV.foreach(file, :headers => true) do |row|
    reading_list << Book.new({
      "book_title" => row["book_title"],
      "goodreads_id" => row["goodreads_id"],
      "isbn" => row["isbn"],
      "isbn13" => row["isbn13"],
      "asin" => row["asin"],
      "image_url" => row["image_url"],
      "publication_year" => row["publication_year"],
      "publication_month" => row["publication_month"],
      "publication_day" => row["publication_day"],
      "publisher" => row["publisher"],
      "language_code" => row["language_code"],
      "description" => row["description"],
      "num_pages" => row["num_pages"],
      "format" => row["format"],
      "url" => row["url"],
      "link" => row["link"],
      "authors" => row["authors"]
    })
  end
  reading_list
end

def export_csv(file, books_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["book_title", "goodreads_id", "isbn", "isbn13", "image_url", "publication_year", "publication_month", "publication_day", "publisher", "language_code", "description", "num_pages", "format", "url", "link", "authors"]) do |csv|
    books_array.each do |book|
      puts "exporting #{book.title}"
      csv << [book.title, book.goodreads_id, book.isbn, book.isbn13, book.image_url, book.publication_year, book.publication_month, book.publication_day, book.publisher, book.language_code, book.description, book.num_pages, book.book_format, book.url, book.link, book.authors]
    end
  end
end

bookshelf = read_csv(DB_FILE)
add_book_details(bookshelf)
export_csv(EXPORT_DB_FILE, bookshelf)
