require "csv"
DB_FILE = "./books.csv"
EXPORT_DB_FILE = "./other.csv"

def generate_read_dates()
  array = []
  10.times do 
    array << "Summer 2010"
  end

  8.times do 
    array << "Fall 2010"
  end

  8.times do 
    array << "Winter 2011"
  end

  14.times do 
    array << "Spring 2011"
  end

  5.times do 
    array << "Summer 2011"
  end

  11.times do 
    array << "Fall 2011"
  end

  15.times do 
    array << "Winter 2012"
  end

  13.times do 
    array << "Spring 2012"
  end

  9.times do 
    array << "Summer 2012"
  end

  16.times do 
    array << "Fall 2012"
  end

  11.times do 
    array << "Winter 2013"
  end

  15.times do 
    array << "Spring 2013"
  end

  14.times do 
    array << "Summer 2013"
  end

  15.times do 
    array << "Fall 2013"
  end

  11.times do 
    array << "Winter 2014"
  end

  10.times do 
    array << "Spring 2014"
  end

  6.times do 
    array << "Summer 2014"
  end

  10.times do 
    array << "Fall 2014"
  end

  11.times do 
    array << "Winter 2015"
  end

  10.times do 
    array << "Spring 2015"
  end

  3.times do 
    array << "Summer 2015"
  end

  0.times do 
    array << "Fall 2015"
  end

  array
end

DB_FILE = "./books.csv"
class Book
  attr_accessor :title, :goodreads_id, :isbn, :isbn13, :asin, :image_url, :publication_year, :publication_month, :publication_day, :publisher, :language_code, :description, :work, :num_pages, :book_format, :url, :link, :authors, :series_works
  def initialize(args = {})
    @title = args['book_title']
    @goodreads_id = args['goodreads_id']
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

def export_csv(file, books_array, reads)
  index = 0

  CSV.open(file, "wb", :write_headers=> true, :headers => ["book_title", "read_date", "goodreads_id", "isbn", "isbn13", "image_url", "publication_year", "publication_month", "publication_day", "publisher", "language_code", "description", "num_pages", "format", "url", "link", "authors"]) do |csv|
    books_array.each do |book|
      puts "exporting #{book.title}, read #{reads[index]}"
      csv << [book.title, reads[index], book.goodreads_id, book.isbn, book.isbn13, book.image_url, book.publication_year, book.publication_month, book.publication_day, book.publisher, book.language_code, book.description, book.num_pages, book.book_format, book.url, book.link, book.authors]
      index = index + 1
    end
  end
end

dates = generate_read_dates()
bookshelf = read_csv(DB_FILE)
export_csv(EXPORT_DB_FILE, bookshelf, dates)