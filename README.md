Rest API template
=========

A sample rails api project.

## Technology

1. Ruby v2.4.0
2. Rails v5.1
3. Rails API

## Setup
### System dependencies
---------------------------------------------------

    bundle install

### Configuration
---------------------------------------------------

    ./configure

### Database
---------------------------------------------------

    bundle exec rails db:create

    bundle exec rails db:migrate

    bundle exec rails db:test:prepare

### Run application
---------------------------------------------------

    bundle exec rails s -p 3000

### How to run the test suite
---------------------------------------------------

    bundle exec rspec
      or
    COVERAGE=true bundle exec rspec
      or
    bundle exec guard [Watches every file save and runs the specs]
    (make changes Guardfile that suits your need)

### How to run code analyzers
---------------------------------------------------

* Rubocop

        bundle exec rubocop

* Rubycritic

        bundle exec rubycritic
          or
        bundle exec reek [Runs in console]

### Interactive Session via Terminal
---------------------------------------------------

    bundle exec rails c

### How to use annotate gem
---------------------------------------------------

For generating schema information in model file

    annotate --exclude tests,fixtures,factories,serializers

### Services (job queues, cache servers, search engines, etc.)
---------------------------------------------------

  ......

### Deployment instructions
---------------------------------------------------

  ......
