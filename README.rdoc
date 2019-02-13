# README
Make sure you have postgres installed with a valid user/pass and you followed **INSTRUCTIONS.html**

#### Clone the repo
`git clone git@github.com:mayesa/mancrates.git`

#### Enter the directory
`cd mancrates`

#### Edit config/database
`vi config/database.yml`

use something like

```
development:
  adapter: postgresql
  encoding: unicode
  database: orderplex_development
  pool: <%= ENV.fetch('RAILS_MAX_THREADS') { 5 } %>
  username: user
  password: pass

test:
  adapter: postgresql
  encoding: unicode
  database: orderplex_test
  pool: 5
  username: user
  password: pass

production:
  adapter: postgresql
  encoding: unicode
  database: orderplex_production
  pool: 5
  username: postgres
  username: user
  password: pass
```

#### Install all dependencies
run `bundle install`

#### Populate the db and seeds
run `rake db:create; rake db:migrate; rake db:seed`

#### Run tests
`bundle exec rspec` to run tests

#### Start Server
If you want to see the app in action, start the server with `rails s`. Then with your browser you can go to  see all orders http://localhost:3000/orders or create a new order http://localhost:3000/orders/new
