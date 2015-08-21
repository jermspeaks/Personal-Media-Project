// var fs = require('fs');
// var bookFile = __dirname + '/Books/books.json';
// var movieFile = __dirname + '/Movies/watched-movies.json';

// function readFiles(file) {
//   fs.readFile(file, 'utf8', function (err, data) {
//     if (err) {
//       console.log('Error: ' + err);
//       return;
//     }

//     data = JSON.parse(data);

//     console.dir(data[0]);
//   });
// }

// readFiles(bookFile);
// readFiles(movieFile);
module.exports = {
    // Load One Data Point into localStorage
    init: function() {
        localStorage.clear();
        localStorage.setItem('movies', JSON.stringify([{
            "movie_title": "Ferris Bueller's Day Off",
            "imdb_link": "http://www.imdb.com/title/tt0091042",
            "imdb_id": "tt0091042",
            "watched_date": "01/2010",
            "tagline": "While the rest of us were just thinking about it...Ferris borrowed a Ferrari and did it...all in a day.",
            "plot": "A high school wise guy is determined to have a day off from school, despite what the principal thinks of that.",
            "runtime": "6180",
            "rating": "7.9",
            "votes": "221018",
            "poster_url": "http://ia.media-imdb.com/images/M/MV5BMTg2MTUxODY4NV5BMl5BanBnXkFtZTcwNzQ5NzU2OQ@@._V1_.jpg",
            "genres": "Comedy",
            "release_date": "1986-06-11"
        }]));
    }
};