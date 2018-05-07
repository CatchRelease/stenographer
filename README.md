# Stenographer
Stenographer is a simplistic way to manage your changes and show them to the users.

## Usage
To create a new item:
```ruby
Stenography::Change.create(message: 'My Change', change_type: 'new/improved/fixed', visible: true, environment: 'production', tracker_ids: '#12345', source: '{}')
```
It's advised to store the source so you can parse it again later if needed.

To View:
```
Open a browser to http://host:port/stenographer or whatever you've set your mount point to.
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stenographer'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install stenographer
```

Run the migrations:
```bash
$ rake stenographer:install:migrations
$ rake db:migrate
```

Mount the engine:
```ruby
  mount Stenographer::Engine, at: '/stenographer'
```

## Configuration
All configuration is available in the config/initializers/stenographer.rb

## Contributing
1. Fork the repo and create your branch.
2. If you've added code that should be tested, add tests.
4. Ensure the test suite passes using `$ rake spec`.
5. Make sure your code lints using `$ rubocop`.
6. Issue that pull request!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
