var MovieActions = require('../actions/MovieActions');

module.exports = {

  // Load mock product data from localStorage into ProductStore via Action
  getMovieData: function() {
    var data = JSON.parse(localStorage.getItem('movies'));
    MovieActions.receiveProduct(data);
  }

};