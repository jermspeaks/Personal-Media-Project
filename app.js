var fs = require('fs');
var bookFile = __dirname + '/Books/books.json';
var movieFile = __dirname + '/Movies/watched-movies.json';

function readFiles(file) {
  fs.readFile(file, 'utf8', function (err, data) {
    if (err) {
      console.log('Error: ' + err);
      return;
    }

    data = JSON.parse(data);

    console.dir(data[0]);
  });
}

readFiles(bookFile);
readFiles(movieFile);