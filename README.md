Build status: [![Circle CI](https://circleci.com/gh/Coaxial/ct/tree/master.svg?style=svg&circle-token=9b7b005560a3e11c1149224fdcfb96c2efd9c39d)](https://circleci.com/gh/Coaxial/ct/tree/master)

# Cheap Thrills
This app scrapes the Cheap Thrills website and shows the upcoming concerts for sale at the store.

It uses an ActiveJob that runs every day to refresh the information. The HTML is then parsed to meaningful data and
saved to a model. Sold out concerts are scraped but hidden from the main page.

The app is deployed at https://cheapthrills.herokuapp.com

# Setup
## Database
`$ cp config/database.yml.example config/database.yml`

# Tests
## Running the test suite
`$ rspec spec` or `$ zeus start` in one terminal and `$ zeus test` in another.

# TODO
  - Paginate concerts
  - Toggle hiding/showing sold out concerts
  - Query Spotify for Artist page/sample music
  - Improve test coverage (views)
  - Handle cases when the HTML page has unparseable data
  - Handle duplicate entries when rescraping the page
