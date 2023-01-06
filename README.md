# popular-movie-predictor
I analyzed a movie database and compared the budget, vote average, and popularity of each movie with it’s revenue to see which movies made the highest revenue with these particular factors in mind. After computing this result, I then looked further into the database to see the producing companies of the movies with such revenues. Analyzing the data in this way can prove to be a helpful indicator on how producing companies should target their customers, as well as helping customers select movies that they want to watch.

I found a dataset on Kaggle with various information regarding thousands of movies. The dataset included several different columns that gave me access to different types of data needed to make predictions with. In specific the columns were:

* homepage
* id
* original_title
* overview, popularity
* production_companies
* production_countries
* release_date
* spoken_languages
* status
* tagline
* vote_average

Some of the data were given in an array format where I was able to use string manipulation to extract the data that was necessary (when I was looking for the names of the movie producer companies).

The link to the dataset is: https://www.kaggle.com/datasets/tmdb/tmdb-movie-metadata
