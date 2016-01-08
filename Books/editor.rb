require "csv"
require "goodreads"

DB_FILE = "./export.csv"
EXPORT_DB_FILE = "./export-new.csv"
class Book
  attr_accessor :title, :read_date, :goodreads_id, :isbn, :isbn13, :asin, :image_url, :publication_year, :publication_month, :publication_day, :publisher, :language_code, :description, :work, :num_pages, :book_format, :url, :link, :authors, :series_works
  def initialize(args = {})
    @title = args['book_title']
    @read_date = args['read_date']
    @goodreads_id = args['id']
    @isbn = args['isbn']
    @isbn13 = args['isbn13']
    @asin = args['asin']
    @image_url = args['image_url']
    @publication_year = args['publication_year']
    @publication_month = args['publication_month']
    @publication_day = args['publication_day']
    @publisher = args['publisher']
    @language_code = args['language_code']
    @description = args['description']
    @work = args['work']
    @num_pages = args['num_pages']
    @book_format = args['format']
    @url = args['url']
    @link = args['link']
    @authors = args['authors']
    @series_works = args['series_works']
  end
end

def create_goodreads_client
  Goodreads::Client.new(:api_key => 'Z0CC2Sg1ZL5I9vHbHrdBfg', :api_secret => 'LZP8vOsOMS5g0YdbiNW1XGk3SpYLezQYi3DmI3UZo')
end

def add_book_details(books)
  goodreads_client = create_goodreads_client()
  books.map do |book|
    puts "Looking for: #{book.title}..."

    if book.isbn
      goodreads_book = goodreads_client.book_by_isbn(book.isbn)
    else
      goodreads_book = goodreads_client.book_by_title(book.title)
    end

    puts "Found book on Goodreads: #{goodreads_book.title}"

    book.goodreads_id = goodreads_book.id
    book.isbn13 = goodreads_book.isbn13
    book.asin = goodreads_book.asin
    book.image_url = goodreads_book.image_url
    book.publication_year = goodreads_book.publication_year
    book.publication_month = goodreads_book.publication_month
    book.publication_day = goodreads_book.publication_day
    book.publisher = goodreads_book.publisher
    book.language_code = goodreads_book.language_code

    if !book.description
      book.description = goodreads_book.description
    end

    book.work = goodreads_book.work
    book.num_pages = goodreads_book.num_pages
    book.book_format = goodreads_book.format
    book.url = goodreads_book.url
    book.link = goodreads_book.link

    begin
      authors = goodreads_book.authors.author.map do |author|
        author.name
      end
      book.authors = authors.join(", ")
    rescue
      book.authors = goodreads_book.authors.author.name
    end
    # puts "Authors: #{book.authors}"

    book.series_works = goodreads_book.series_works
    book
  end
end

# Read through CSV file and push book into reading_list
def read_csv(file)
  reading_list = []
  CSV.foreach(file, :headers => true) do |row|
    reading_list << Book.new({
      'book_title' => row['book_title'],
      'isbn' => row['isbn'],
      'description' => row['description'],
      'read_date' => row['read_date']
    })
  end
  reading_list
end

def export_csv(file, books_array)
  CSV.open(file, "wb", :write_headers=> true, :headers => ["book_title", "read_date", "goodreads_id", "isbn", "isbn13", "image_url", "publication_year", "publication_month", "publication_day", "publisher", "language_code", "description", "num_pages", "format", "url", "link", "authors"]) do |csv|
    books_array.each do |book|
      puts "exporting #{book.title}"
      csv << [book.title, book.read_date, book.goodreads_id, book.isbn, book.isbn13, book.image_url, book.publication_year, book.publication_month, book.publication_day, book.publisher, book.language_code, book.description, book.num_pages, book.book_format, book.url, book.link, book.authors]
    end
  end
end

bookshelf = read_csv(DB_FILE)
add_book_details(bookshelf)
export_csv(EXPORT_DB_FILE, bookshelf)